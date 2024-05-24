import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:colab_care/controllers/Home_Screen/mindfulness/player_screen.dart';
import 'package:provider/provider.dart';

class MindfulnessItem extends StatelessWidget {
  final int index;
  final VoidCallback onPressed;
  final String imagePath;
  final String itemText;
  final String itemDesc;
  final int duration;
  final String trackExt;
  final String backvid;
  final String audio;
  final String audioExt;

  const MindfulnessItem({
    required this.index,
    required this.onPressed,
    required this.imagePath,
    required this.itemText,
    required this.itemDesc,
    Key? key,
    required this.duration,
    required this.trackExt,
    required this.backvid,
    required this.audio,
    required this.audioExt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlayerInfoScreen(
              index: index,
              onPressed: onPressed,
              imagePath: imagePath,
              itemText: itemText,
              descriptions: itemDesc,
              duration: duration,
              trackExtension: trackExt,
              backvid: backvid,
              audio: audio,
              audioExt: audioExt,
            ),
          ),
        );
      },
      child: Container(
        height: 120.0,
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        decoration: BoxDecoration(
          color: theme.borderColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                imagePath,
                height: 120.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Text(
                itemText,
                style: const TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerInfoScreen extends StatelessWidget {
  final int index;
  final VoidCallback onPressed;
  final String imagePath;
  final String itemText;
  final String descriptions;
  final int duration;
  final String trackExtension;
  final String backvid;
  final String audio;
  final String audioExt;

  const PlayerInfoScreen({
    required this.index,
    required this.onPressed,
    required this.imagePath,
    required this.itemText,
    required this.descriptions,
    required this.duration,
    required this.trackExtension,
    required this.backvid,
    Key? key,
    required this.audio,
    required this.audioExt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 11, // Set the aspect ratio as needed
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 26.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Audio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Text(
                      '${duration ~/ 60}M ${duration % 60}S',
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Text(
                    itemText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 26.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white, // Text color
                    minimumSize: const Size(
                        150, 40), // Minimum width and height of the button
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(
                          itemIndex: index,
                          backvid: backvid,
                          audio: audio,
                          audioExt: audioExt,
                          duration: duration,
                          itemText: itemText,
                        ),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow),
                      SizedBox(width: 8),
                      Text(
                        'Play',
                        style: TextStyle(fontSize: 20.0),
                      ), // Button text
                    ],
                  ),
                ),
                const SizedBox(height: 26.0),
                Text(
                  descriptions,
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
