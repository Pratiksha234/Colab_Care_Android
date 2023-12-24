import 'package:colab_care/Shared_preferences.dart';
import 'package:colab_care/controllers/Home_Screen/daily_checkin.dart';
import 'package:colab_care/controllers/Home_Screen/profile_screen.dart';
import 'package:colab_care/controllers/Themes/theme_controller.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:colab_care/controllers/Themes/themes.dart';
import 'package:intl/intl.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String motivationalMessage = "Loading...";
  String firstName = "User";
  String userEmail = '';
  late ThemeProtocol currentTheme;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    currentTheme = DefaultTheme();
  }

  void fetchUserData() async {
    Map<String, String> userData =
        await SharedPreferencesUtils.getUserDataFromSharedPreferences();
    setState(() {
      userEmail = userData['new_email'] ?? '@gmail.com';
      firstName = userData['first_name'] ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('quotes');
    DateTime now = DateTime.now();
    String formattedDay = DateFormat('dd').format(now);
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;
    dbRef.onValue.listen((event) {
      setState(() {
        String specificValue =
            event.snapshot.child(formattedDay).value.toString();
        motivationalMessage = specificValue;
      });
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(100.0), // Set your desired height here
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 20.0,
                    bottom: 8.0), // Adjust padding as needed
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Home',
                    style: theme.navbarFont,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 0.0, left: 20.0, bottom: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
          backgroundColor: theme.backgroundGradientStart,
          centerTitle: false,
          titleSpacing: 0,
        ),
      ),
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.asset(
                theme.backgroundImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '👋 Hello, $firstName!',
                    style: theme.headerFont,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    motivationalMessage,
                    style: theme.textFont,
                  ),
                ),
                // Centered Daily Check-In button
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          theme.buttonTintColor),
                      // You can adjust other properties here, such as text color, padding, etc.
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DailyCheckInForm()),
                      );
                    },
                    child: Text(
                      'Daily Check-In',
                      style: theme.textFont,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.buttonTintColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ThemeSelectionScreen()),
          );
        },
        child: const Icon(Icons.brush),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
