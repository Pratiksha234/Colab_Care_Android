import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:colab_care/controllers/Home_Screen/home/home_screen.dart';
import 'package:colab_care/controllers/Home_Screen/mindfulness/Mindfullness.dart';
import 'package:colab_care/controllers/Home_Screen/goals/goals_screen.dart';
import 'package:colab_care/controllers/Home_Screen/messaging/messaging.dart';
import 'package:colab_care/controllers/Home_Screen/reminders/medication.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      const MessagingScreen(),
      const MindfulnessScreen(),
      const GoalsScreen(),
      const MedicationScreen(),
    ];
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return WillPopScope(
      // Prevents the app from logging out when pressing the back button
      onWillPop: () async {
        if (_currentIndex == 0) {
          return true; // Allow the app to exit if on the home screen
        } else {
          setState(() {
            _currentIndex = 0; // Navigate to the home screen
          });
          return false; // Prevent the app from exiting
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: theme.tabBarBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10), // Raises the bar up
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent, // Make it transparent
              elevation: 0, // Remove shadow
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              unselectedItemColor: theme.tabBarUnselectedItemColor,
              selectedItemColor: theme.tabBarSelectedItemColor,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.message), label: 'Messaging'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: 'Mindfulness'),
                BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Goals'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.medication), label: 'Medication'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
