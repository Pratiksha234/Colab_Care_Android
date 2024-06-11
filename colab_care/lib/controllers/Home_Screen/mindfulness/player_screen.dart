import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:colab_care/models/meditation_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PlayerScreen extends StatefulWidget {
  final Meditation meditation;

  const PlayerScreen({
    super.key,
    required this.meditation,
  });

  @override
  State<StatefulWidget> createState() {
    return _PlayerScreenState();
  }
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _videoController;
  late AudioPlayer _audioPlayer;
  bool _isVideoInitialized = false;
  // final bool _isLooping = false;

  late StreamController<Duration> _audioPositionStreamController;
  late StreamController<Duration> _videoPositionStreamController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
    _audioPositionStreamController = StreamController<Duration>();
    _videoPositionStreamController = StreamController<Duration>();
  }

  void initializePlayer() async {
    final fileInfo = await DefaultCacheManager()
        .getFileFromCache('videos/${widget.meditation.backgroundVideo}.mp4');
    String videoPath;

    if (fileInfo == null) {
      // If video is not in cache, download it and add to cache
      try {
        final videoUrl = await FirebaseStorage.instance
            .ref('videos/${widget.meditation.backgroundVideo}.mp4')
            .getDownloadURL();
        final file = await DefaultCacheManager().getSingleFile(videoUrl);
        videoPath = file.path;
      } catch (e) {
        // print("Error fetching or caching video: $e");
        return;
      }
    } else {
      // Use cached video
      videoPath = fileInfo.file.path;
    }

    // Initialize video controller with local file
    _videoController = VideoPlayerController.file(File(videoPath))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
          });
          _videoController.play(); // Start video playback
        }
      })
      ..setLooping(true); // Set video to loop

    _audioPlayer = AudioPlayer();
    try {
      await _audioPlayer.setSourceAsset(
          'audio/${widget.meditation.track}.${widget.meditation.trackExtension}');
      _audioPlayer.onPositionChanged.listen((event) {
        _audioPositionStreamController.add(event);
      });

      _videoController.addListener(() {
        if (_videoController.value.isInitialized) {
          Duration position = _videoController.value.position;
          _videoPositionStreamController.add(position);
        }
      });

      // Ensure media focus is handled properly
      _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
        if (state == PlayerState.playing) {
          _videoController.play();
        } else if (state == PlayerState.paused) {
          _videoController.play();
        }
      });
    } catch (e) {
      // print("Error initializing audio player: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _videoPositionStreamController.close();
    _audioPositionStreamController.close();

    _videoController.dispose();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isVideoInitialized
          ? Stack(
              children: [
                // Video Backdrop
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: VideoPlayer(_videoController),
                    ),
                  ),
                ),
                // Black opacity overlay
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                  ),
                ),
                // Overlay UI
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      // Audio Title
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.meditation.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                          ),
                        ),
                      ),
                      // Audio controls and progress indicator
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: audioProgressIndicator(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: audioControlRow(),
                            )
                            // Audio controls
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget audioControlButton(IconData icon, int seconds) {
    return IconButton(
      iconSize: 40, // Adjust button size as needed
      icon: Icon(icon, color: Colors.white),
      onPressed: () async {
        final currentPosition = await _audioPlayer.getCurrentPosition();
        final seekPosition =
            Duration(seconds: currentPosition!.inSeconds + seconds);
        _audioPlayer.seek(seekPosition);
      },
    );
  }

  Widget playPauseButton() {
    return IconButton(
      iconSize: 50,
      icon: StreamBuilder<PlayerState>(
        stream: _audioPlayer.onPlayerStateChanged,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state == PlayerState.playing) {
            return const Icon(Icons.pause_circle_filled, color: Colors.white);
          }
          return const Icon(Icons.play_circle_filled, color: Colors.white);
        },
      ),
      onPressed: () {
        if (_audioPlayer.state == PlayerState.playing) {
          _audioPlayer.pause();
        } else {
          _audioPlayer.resume();
        }
      },
    );
  }

  Widget audioControlRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Replay button
        audioControlButton(
          Icons.replay_10,
          -10,
        ),
        // Play/Pause button
        playPauseButton(),
        // Forward button
        audioControlButton(
          Icons.forward_10,
          10,
        ),
        // Repeat Button
        // IconButton(
        //     iconSize: 40,
        //     icon: const Icon(Icons.repeat, color: Colors.white),
        //     onPressed: () async {
        //       // Toggling repeat mode
        //       if (!_isLooping) {
        //         _audioPlayer.setReleaseMode(
        //             ReleaseMode.loop); // Enable repeat for one track
        //       } else {
        //         _audioPlayer.setReleaseMode(ReleaseMode.loop); // Disable repeat
        //       }
        //     }),
        // Stop button - Exit button
        IconButton(
          iconSize: 40,
          icon: const Icon(Icons.stop, color: Colors.white),
          onPressed: () {
            // Ensure audio playback is stopped
            _audioPlayer.stop();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget audioProgressIndicator() {
    return StreamBuilder<Duration>(
      stream: _audioPositionStreamController.stream,
      builder: (context, snapshot) {
        Duration position = snapshot.data ?? Duration.zero;
        return Column(
          children: [
            Slider(
              value: position.inSeconds.toDouble(),
              min: 0,
              max: widget.meditation.duration.toDouble(),
              onChanged: (value) {
                Duration seekPos = Duration(
                  seconds: value.toInt(),
                );
                _audioPlayer.seek(seekPos);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDuration(position),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    formatDuration(
                      Duration(seconds: widget.meditation.duration) - position,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}
