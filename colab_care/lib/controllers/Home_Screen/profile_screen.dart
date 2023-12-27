import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:colab_care/Shared_preferences.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userName = 'User';
  String userEmail = '';
  String profilePictureURL = '';

  @override
  void initState() {
    super.initState();
    setProfileInfo();
    // setProfileImage();
  }

  void setProfileInfo() async {
    Map<String, String> userData =
        await SharedPreferencesUtils.getUserDataFromSharedPreferences();

    setState(() {
      userEmail = userData['new_email'] ?? '@gmail.com';
      userName = userData['first_name'] ?? 'User';
    });
  }

  // void setProfileImage() {
  //   final user = _auth.currentUser;
  //   if (user != null) {
  //     setState(() {
  //       profilePictureURL = user.photoURL ?? '';
  //     });
  //   }
  // }

  void logout() async {
    await _auth.signOut();
    Navigator.pop(context); // Pop ProfileScreen
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Profile'),
        ),
        backgroundColor: theme.tabBarBackgroundColor,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: theme.tabBarBackgroundColor,
                backgroundImage: profilePictureURL.isNotEmpty
                    ? NetworkImage(profilePictureURL)
                    : null,
                child: profilePictureURL.isEmpty
                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                'Name: $userName',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Email: $userEmail',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
