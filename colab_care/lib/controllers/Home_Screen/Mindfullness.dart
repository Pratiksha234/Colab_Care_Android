import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MindfulnessScreen extends StatelessWidget {
  const MindfulnessScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    List<String> itemTexts = [
      '5 Min Body Scan',
      'Mindful Movement',
      'Simple Listening for Grounding',
      'Sitting Meditation',
      'Sleep Meditation',
      '10 Min Breathing Exercise',
      '10 Min Body Scan',
      '3 Min Breathing Space',
      'Walking Meditation',
    ];
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Mindfulness'),
        ),
        backgroundColor: theme.tabBarBackgroundColor,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: theme.backgroundGradientStart,
        child: ListView.builder(
          itemCount: 9,
          itemBuilder: (context, index) {
            return MindfulnessItem(
              index: index,
              onPressed: () {
                // Navigate to the video and audio player screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayerScreen(itemIndex: index),
                  ),
                );
              },
              imagePath:
                  'assets/mindfulness/photo$index.jpg', // Change this to your image path
              itemText: itemTexts[index], // Use the text from the list
            );
          },
        ),
      ),
    );
  }
}

class MindfulnessItem extends StatelessWidget {
  final int index;
  final VoidCallback onPressed;
  final String imagePath;
  final String itemText;

  const MindfulnessItem({
    required this.index,
    required this.onPressed,
    required this.imagePath,
    required this.itemText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 120.0,
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        decoration: BoxDecoration(
          color: Colors.grey[120],
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
                style: TextStyle(
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

class PlayerScreen extends StatelessWidget {
  final int itemIndex;

  const PlayerScreen({required this.itemIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player for Item $itemIndex'),
      ),
      body: Center(
        child: Text('Video and Audio Player for Item $itemIndex'),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: MindfulnessScreen(),
    ),
  );
}
