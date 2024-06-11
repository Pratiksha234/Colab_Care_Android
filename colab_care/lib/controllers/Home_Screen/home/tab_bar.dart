// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Internal
import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:colab_care/controllers/Home_Screen/home/home_screen.dart';
import 'package:colab_care/controllers/Home_Screen/mindfulness/mindfulness_screen.dart';
import 'package:colab_care/controllers/Home_Screen/goals/goals_screen.dart';
import 'package:colab_care/controllers/Home_Screen/messaging/messaging.dart';
import 'package:colab_care/controllers/Home_Screen/reminders/medication.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // The List of Tab screens
    final List<Widget> screens = [
      const HomeScreen(),
      const MessagingScreen(),
      const MindfulnessScreen(),
      const GoalsScreen(),
      const MedicationScreen(),
    ];
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.tabBarBackgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8), // Raises the bar up
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent, // Make it transparent
            elevation: 0, // Remove shadow
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            unselectedItemColor: theme.tabBarUnselectedItemColor,
            selectedItemColor: theme.tabBarSelectedItemColor,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Messaging',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Mindfulness',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.flag),
                label: 'Goals',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.medication),
                label: 'Medication',
              ),
            ],
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
