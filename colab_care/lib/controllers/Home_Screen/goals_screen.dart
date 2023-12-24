import 'package:colab_care/Shared_preferences.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SharedPreferencesUtils.getUserDataFromSharedPreferences();
    final theme = Provider.of<ThemeNotifier>(context)
        .currentTheme; // Access the current theme

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Goals'),
        ),
        backgroundColor: theme.tabBarBackgroundColor,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
    );
  }
}
