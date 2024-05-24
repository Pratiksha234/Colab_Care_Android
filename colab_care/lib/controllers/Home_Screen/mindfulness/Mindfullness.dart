import 'package:colab_care/controllers/Home_Screen/mindfulness/mindfulness_item.dart';
import 'package:colab_care/controllers/Home_Screen/mindfulness/player_screen.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Meditation {
  final String title;
  final String description;
  final int duration;
  final String track;
  final String trackExtension;
  final String image;
  final String backgroundVideo;

  Meditation({
    required this.title,
    required this.description,
    required this.duration,
    required this.track,
    required this.trackExtension,
    required this.image,
    required this.backgroundVideo,
  });
}

class MindfulnessScreen extends StatelessWidget {
  const MindfulnessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Meditation> mindfulnessItems = [
      Meditation(
          title: "Simple Listening for Grounding",
          description:
              "Amidst the chaos, find solace in the simplicity of listening. Ground yourself in the present moment, for it holds the whispers of wisdom.",
          duration: 179,
          track: "SimplyListeningforGrounding",
          trackExtension: "mp3",
          image: "assets/mindfulness/photo2.jpg",
          backgroundVideo: "simplyListen"),
      Meditation(
          title: "10 Min Breathing Exercise",
          description:
              "Take just ten minutes to breathe, and witness how the rhythm of your breath can restore calm, renew energy, and bring profound peace to your being.",
          duration: 665,
          track: "TenMinBreathing",
          trackExtension: "m4a",
          image: "assets/mindfulness/photo5.jpg",
          backgroundVideo: "tenMinBreathe"),
      Meditation(
          title: "3 Min Breathing Space",
          description:
              "In the sanctuary of a three-minute breathing space, find respite from the chaos, reconnect with your essence, and emerge with clarity, strength, and a renewed sense of presence.",
          duration: 179,
          track: "ThreeMinBreathingSpace",
          trackExtension: "m4a",
          image: "assets/mindfulness/photo7.jpg",
          backgroundVideo: "threeMinBreatheSpace"),
      Meditation(
          title: "10 Min Body Scan",
          description:
              "Embark on a sacred journey within, as you traverse the landscape of your body. In a mere ten minutes, the body scan reveals whispers of wisdom, invites profound relaxation, and unveils the treasures of self-awareness.",
          duration: 661,
          track: "TenMinBodyScan",
          trackExtension: "mp4",
          image: "assets/mindfulness/photo6.jpg",
          backgroundVideo: "tenMinBS"),
      Meditation(
          title: "5 Min Body Scan",
          description:
              "Embark on a five-minute journey within, as you traverse the landscape of your body with gentle awareness. Let the body scan unveil the whispers of sensations, grounding you in the present moment and nurturing a deeper connection with yourself.",
          duration: 364,
          track: "FiveMinBodyScan",
          trackExtension: "m4a",
          image: "assets/mindfulness/photo0.jpg",
          backgroundVideo: "fiveMinBS"),
      Meditation(
          title: "Mindful Movement",
          description:
              "Move with mindful grace, and you will dance through life's challenges.",
          duration: 934,
          track: "MindfulMovement",
          trackExtension: "mp3",
          image: "assets/mindfulness/photo1.jpg",
          backgroundVideo: "mindfulMove"),
      Meditation(
          title: "Sitting Meditation",
          description:
              "In the stillness of sitting meditation, we embrace the art of simply being. As we rest in the sanctuary of our breath and witness the ebb and flow of thoughts, we discover the boundless serenity that resides within us.",
          duration: 844,
          track: "SittingMeditation",
          trackExtension: "mp3",
          image: "assets/mindfulness/photo3.jpg",
          backgroundVideo: "sittingMedi"),
      Meditation(
          title: "Walking Meditation",
          description:
              "Clear your mind and relax your soul and slip into tranquility. Walk slowly and calmly.",
          duration: 285,
          track: "WalkingMeditation",
          trackExtension: "mp3",
          image: "assets/mindfulness/photo8.jpg",
          backgroundVideo: "walking"),
      Meditation(
          title: "Sleep Meditation",
          description:
              "Enter the realm of sleep meditation, where the whispers of tranquility guide you into the arms of peaceful slumber. As you surrender to the embrace of each breath, may your dreams be adorned with serenity and awaken to a renewed sense of vitality.",
          duration: 591,
          track: "SleepMeditation",
          trackExtension: "mp3",
          image: "assets/mindfulness/photo4.jpg",
          backgroundVideo: "sleepMedi")
    ];

    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      backgroundColor: theme.backgroundGradientStart,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Mindfulness',
            style: theme.navbarFont,
          ),
        ),
        backgroundColor: theme.backgroundGradientStart,
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: mindfulnessItems.length,
          itemBuilder: (context, index) {
            return MindfulnessItem(
              index: index,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayerScreen(
                      itemIndex: index,
                      backvid: mindfulnessItems[index].backgroundVideo,
                      audio: mindfulnessItems[index].track,
                      audioExt: mindfulnessItems[index].trackExtension,
                      duration: mindfulnessItems[index].duration,
                      itemText: mindfulnessItems[index].title,
                    ),
                  ),
                );
              },
              imagePath: mindfulnessItems[index].image,
              itemText: mindfulnessItems[index].title,
              itemDesc: mindfulnessItems[index].description,
              duration: mindfulnessItems[index].duration,
              trackExt: mindfulnessItems[index].trackExtension,
              backvid: mindfulnessItems[index].backgroundVideo,
              audio: mindfulnessItems[index].track,
              audioExt: mindfulnessItems[index].trackExtension,
            );
          },
        ),
      ),
    );
  }
}
