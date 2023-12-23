import 'package:colab_care/Shared_preferences.dart';
import 'package:flutter/material.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SharedPreferencesUtils.getUserDataFromSharedPreferences();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Messaging'),
        ),
        backgroundColor: const Color.fromRGBO(156, 154, 255, 100),
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
