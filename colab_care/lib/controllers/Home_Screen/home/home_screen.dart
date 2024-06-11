import 'package:colab_care/controllers/Home_Screen/home/daily_checkin.dart';
import 'package:colab_care/controllers/Home_Screen/home/home_controller.dart';
import 'package:colab_care/controllers/Home_Screen/home/profile_screen.dart';
import 'package:colab_care/controllers/Themes/theme_controller.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:colab_care/controllers/Themes/themes.dart';

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
  final HomeController _userController = HomeController();
  String _motivationalMessage = "Loading ...";

  String firstName = 'User';
  late ThemeProtocol currentTheme;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _fetchData();
    currentTheme = DefaultTheme();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    firstName = prefs.getString('first_name') ?? '';
  }

  Future<void> _fetchData() async {
    final quote = await _userController.fetchDailyQuote();
    setState(() {
      _motivationalMessage = quote;
    });
  }

  void _openThemesOverlay(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (ctx) => ThemeSelectionScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

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
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
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
                    '👋 Hello, $firstName',
                    style: theme.headerFont,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _motivationalMessage,
                    style: theme.textFont,
                  ),
                ),
                const SizedBox(
                  height: 16,
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
          _openThemesOverlay(context);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ThemeSelectionScreen(),
          //   ),
          // );
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
