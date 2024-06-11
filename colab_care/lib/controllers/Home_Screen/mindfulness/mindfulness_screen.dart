import 'package:colab_care/data/mindfulness_assets.dart';
import 'package:colab_care/widgets/custom_main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:colab_care/controllers/Home_Screen/mindfulness/mindfulness_item.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';

class MindfulnessScreen extends StatelessWidget {
  const MindfulnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      backgroundColor: theme.backgroundGradientStart,
      appBar: const CustomMainAppbar(appBarTitle: "Mindfulness"),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.backgroundGradientStop,
                  theme.backgroundGradientStart,
                ],
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: ListView.builder(
              itemCount: mindfulnessItems.length,
              itemBuilder: (context, index) {
                return MindfulnessItem(
                  meditation: mindfulnessItems[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
