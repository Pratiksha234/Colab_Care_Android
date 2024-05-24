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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String motivationalMessage = "Loading...";
  late String firstName = '';
  String userEmail = '';
  late ThemeProtocol currentTheme;
  late String profile_url = '';

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
    profile_url = prefs.getString('profileImageUrl') ?? '';
    print(profile_url);
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
                    top: 20.0,
                    left: 20.0,
                    bottom: 0.0), // Adjust padding as needed
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Home',
                    style: theme.navbarFont,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0,
                    right: 10.0,
                    left: 30.0,
                    bottom: 0.0), // Adjust padding as needed
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: theme.tabBarBackgroundColor,
                    backgroundImage: profile_url.isNotEmpty
                        ? NetworkImage(profile_url)
                        : null,
                    child: profile_url.isEmpty
                        ? const Icon(Icons.person,
                            size: 70, color: Colors.white)
                        : null,
                  ),
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
                Center(
                  child: Container(
                    width: 250, // Set the width you desire
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_outlined,
                            color: Colors.white,
                          ), // Add the upload icon here
                          SizedBox(
                              width:
                                  8), // Add some spacing between the icon and text
                          Text(
                            'Daily Check-In',
                            style: TextStyle(
                              fontFamily: "TrebuchetMS",
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
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
        heroTag: 'Theme',
        backgroundColor: theme.buttonTintColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ThemeSelectionScreen()),
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
