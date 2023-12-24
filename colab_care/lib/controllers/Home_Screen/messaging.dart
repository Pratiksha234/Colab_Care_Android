import 'package:colab_care/Shared_preferences.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SharedPreferencesUtils.getUserDataFromSharedPreferences();
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Messaging'),
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
