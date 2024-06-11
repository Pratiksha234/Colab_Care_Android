import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:colab_care/controllers/Home_Screen/goals/goals_provider.dart';
import 'package:colab_care/controllers/Home_Screen/home/daily_config.dart';
import 'package:colab_care/controllers/Home_Screen/reminders/reminder_provider.dart';
import 'package:colab_care/controllers/Login-Registration/signin_screen.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:colab_care/database_access.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String firstName = 'User';
  String lastName = '';
  String userEmail = '';
  String profilePictureURL = '';
  String newEmail = '';

  @override
  void initState() {
    super.initState();
    setProfileInfo();
    setProfileImage();
  }

  Future<void> setProfileInfo() async {
    final prefs = await SharedPreferences.getInstance();
    firstName = prefs.getString('first_name') ?? '';
    lastName = prefs.getString('last_name') ?? '';
    userEmail = prefs.getString('email') ?? '';

    newEmail = DatabaseUtils.convertToHyphenSeparatedEmail(userEmail);
    newEmail = "${newEmail}_profile_picture";
    print(newEmail);
    // Reference ref = firebase_storage.FirebaseStorage.instance
    //     .ref()
    //     .child('images/$newEmail.jpg');
    // final data = await ref.getData();
  }

  void logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Update isLoggedIn status
    await prefs.clear();
    await _auth.signOut();

    // Reset providers
    Provider.of<GoalsProvider>(context, listen: false).resetGoals();
    Provider.of<RemindersProvider>(context, listen: false)
        .resetMedicationReminders();
    await AwesomeNotifications().cancelAllSchedules();

    // Navigate to LoginScreen and remove ProfileScreen from the navigation stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }

  Future<void> setProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('email') ?? '';
    String safeEmail = DatabaseUtils.convertToHyphenSeparatedEmail(userEmail);
    String imageFileName =
        "${safeEmail}_profile_picture"; // Assuming JPEG format.

    try {
      final ref = FirebaseStorage.instance.ref('images/${imageFileName}.png');
      final downloadUrl = await ref.getDownloadURL();
      setState(() {
        profilePictureURL =
            downloadUrl; // This is the image URL to be displayed.
      });
      print(downloadUrl);
      // Optionally save the URL in SharedPreferences if you want to cache it.
      await prefs.setString('profileImageUrl', downloadUrl);
    } catch (e) {
      print('Error loading profile picture: $e');
      setState(() {
        profilePictureURL = ''; // Handle error or set a default image.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    final String backgroundImage = theme.backgroundImage;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text('Profile'),
        centerTitle: false,
        backgroundColor: theme.tabBarBackgroundColor,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
      ),
      backgroundColor: theme.backgroundColor,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.backgroundGradientStart,
                  theme.backgroundGradientStop,
                ],
              ),
            ),
          ),
          // Theme photo in the background at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height *
                0.3, // adjust the height as needed
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          // Profile information in the center
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: theme.tabBarBackgroundColor,
                    backgroundImage: profilePictureURL.isNotEmpty
                        ? NetworkImage(profilePictureURL)
                        : null,
                    child: profilePictureURL.isEmpty
                        ? const Icon(Icons.person,
                            size: 70, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$firstName $lastName',
                    style: theme.headerFont,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userEmail,
                    style: theme.captionFont,
                  ),
                  const SizedBox(height: 10),

                  const SizedBox(height: 10), // Space between buttons
                  SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.8, // 80% of screen width
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.help_outline,
                          color: Colors.white), // Icon color
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'User Guide',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            theme.buttonTintColor, // Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        // Implement User Guide navigation
                      },
                    ),
                  ),
                  const SizedBox(height: 10), // Space between buttons

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.settings,
                          color: Colors.white), // Choose an appropriate color
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Configure Daily Check-In',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            theme.buttonTintColor, // Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const DailyCheckInConfigScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10), // Space between buttons

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.exit_to_app, color: Colors.white),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            theme.buttonTintColor, // Logout button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () => logout(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
