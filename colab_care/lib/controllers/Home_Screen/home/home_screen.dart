// import 'package:cached_network_image/cached_network_image.dart';
import 'package:colab_care/controllers/Home_Screen/home/daily_checkin.dart';
import 'package:colab_care/controllers/Home_Screen/home/profile_screen.dart';
import 'package:colab_care/controllers/Themes/theme_controller.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:colab_care/controllers/Themes/themes.dart';
import 'package:intl/intl.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String motivationalMessage = "Loading...";
  late String firstName = '';
  String userEmail = '';
  late ThemeProtocol currentTheme;
  late String profileUrl = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
    currentTheme = DefaultTheme();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    firstName = prefs.getString('first_name') ?? '';
    userEmail = prefs.getString('email') ?? '';
    profileUrl = prefs.getString('profileImageUrl') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('quotes');
    DateTime now = DateTime.now();
    String formattedDay = DateFormat('dd').format(now);

    final theme = Provider.of<ThemeNotifier>(context).currentTheme;
    final topPadding = MediaQuery.of(context).padding.top;

    dbRef.onValue.listen((event) {
      setState(() {
        String specificValue =
            event.snapshot.child(formattedDay).value.toString();
        motivationalMessage = specificValue;
      });
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Home",
          style: theme.navbarFont,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            iconSize: 40,
            icon: Icon(
              Icons.person,
              color: theme.tabBarBackgroundColor,
            ),
          )
        ],
        backgroundColor: theme.backgroundGradientStart,
        centerTitle: false,
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
            top: -topPadding,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(theme.backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.31,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '👋 Hello, $firstName!',
                    style: theme.headerFont,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
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
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.buttonTintColor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DailyCheckInForm()),
                      );
                    },
                    icon: const Icon(
                      Icons.upload_outlined,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Daily Check-In",
                      style: TextStyle(
                        fontFamily: "TrebuchetMS",
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // heroTag: 'Theme',
        backgroundColor: theme.buttonTintColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ThemeSelectionScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.brush,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
