import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PlayerScreen extends StatefulWidget {
  final int itemIndex;
  final String backvid;
  final String audio;
  final String audioExt;

  final int duration;
  final String itemText;

  const PlayerScreen({
    super.key,
    required this.itemIndex,
    required this.backvid,
    required this.audio,
    required this.audioExt,
    required this.duration,
    required this.itemText,
  });

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _videoController;
  late AudioPlayer _audioPlayer;
  bool _isVideoInitialized = false;
  final bool _isLooping = false;

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
    // await Firebase.initializeApp();

    final fileInfo = await DefaultCacheManager()
        .getFileFromCache('videos/${widget.backvid}.mp4');
    String videoPath;

    if (fileInfo == null) {
      // If video is not in cache, download it and add to cache
      try {
        final videoUrl = await FirebaseStorage.instance
            .ref('videos/${widget.backvid}.mp4')
            .getDownloadURL();
        final file = await DefaultCacheManager().getSingleFile(videoUrl);
        videoPath = file.path;
      } catch (e) {
        print("Error fetching or caching video: $e");
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
      await _audioPlayer
          .setSourceAsset('audio/${widget.audio}.${widget.audioExt}');
      _audioPlayer.onPositionChanged.listen((event) {
        _audioPositionStreamController.add(event);
      });

      _videoController.addListener(() {
        if (_videoController.value.isInitialized) {
          Duration position = _videoController.value.position;
          _videoPositionStreamController.add(position);
        }
      });
    } catch (e) {
      print("Error initializing audio player: $e");
    }
  }

  @override
  void dispose() {
    _videoPositionStreamController.close();
    _audioPositionStreamController.close();

    _videoController.dispose();
    _audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isVideoInitialized
          ? Stack(
              children: [
                // Video Player
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

                // Overlay UI
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.itemText,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 30),
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
        iconSize: 40, // Adjust button size as needed
        icon: StreamBuilder<PlayerState>(
            stream: _audioPlayer.onPlayerStateChanged,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state == PlayerState.playing) {
                return const Icon(Icons.pause, color: Colors.white);
              }
              return const Icon(Icons.play_arrow, color: Colors.white);
            }),
        onPressed: () {
          if (_audioPlayer.state == PlayerState.playing) {
            _audioPlayer.pause();
          } else {
            _audioPlayer.resume();
          }
        });
  }

  Widget audioControlRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        audioControlButton(Icons.replay_10, -10), // Replay button
        playPauseButton(), // Play/Pause button
        audioControlButton(Icons.forward_10, 10), // Forward button
        IconButton(
            iconSize: 40,
            icon: const Icon(Icons.repeat, color: Colors.white),
            onPressed: () async {
              // Toggling repeat mode
              if (!_isLooping) {
                _audioPlayer.setReleaseMode(
                    ReleaseMode.loop); // Enable repeat for one track
              } else {
                _audioPlayer.setReleaseMode(ReleaseMode.loop); // Disable repeat
              }
            }),
        // Repeat button
        IconButton(
            iconSize: 40,
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              _audioPlayer.stop(); // Ensure audio playback is stopped
              Navigator.of(context).pop(); // Navigate back or close the screen
            }) // Exit button
      ],
    );
  }

  Widget audioProgressIndicator() {
    return StreamBuilder<Duration>(
        stream: _audioPositionStreamController.stream,
        builder: (context, snapshot) {
          Duration position = snapshot.data ?? Duration.zero;
          return Column(children: [
            Slider(
                value: position.inSeconds.toDouble(),
                min: 0,
                max: widget.duration.toDouble(),
                onChanged: (value) {
                  Duration seekPos = Duration(seconds: value.toInt());
                  _audioPlayer.seek(seekPos);
                }),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatDuration(position),
                          style: const TextStyle(color: Colors.white)),
                      Text(
                          formatDuration(
                              Duration(seconds: widget.duration) - position),
                          style: const TextStyle(color: Colors.white))
                    ]))
          ]);
        });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}
