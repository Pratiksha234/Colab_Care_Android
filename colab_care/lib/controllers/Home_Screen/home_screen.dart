import 'package:colab_care/Shared_preferences.dart';
import 'package:colab_care/controllers/Home_Screen/daily_checkin.dart';
import 'package:colab_care/controllers/Home_Screen/medication.dart';
import 'package:colab_care/controllers/Home_Screen/messaging.dart';
import 'package:colab_care/controllers/Home_Screen/profile_screen.dart';
import 'package:colab_care/controllers/Themes/themes.dart';
import 'package:intl/intl.dart';

import 'package:colab_care/controllers/Home_Screen/Mindfullness.dart';
import 'package:colab_care/controllers/Home_Screen/goals_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const HomeScreen(),
      const MindfulnessScreen(),
      GoalScreen(),
      const MessagingScreen(),
      const MedicationScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        selectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(color: Colors.black),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
            icon: Icon(Icons.message),
            label: 'Messaging',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Medication',
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String motivationalMessage = "Loading..."; // Initial message
  String firstName = "User"; // Default value
  String userEmail = '';
  late ThemeProtocol currentTheme;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    currentTheme = DefaultTheme();
  }

  void fetchUserData() async {
    // Retrieve user data from SharedPreferences
    Map<String, String> userData =
        await SharedPreferencesUtils.getUserDataFromSharedPreferences();

    // Update state with user data
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
    // print(formattedDay);
    dbRef.onValue.listen(
      (event) {
        setState(() {
          String specificValue =
              event.snapshot.child(formattedDay).value.toString();

          motivationalMessage = specificValue;
        });
      },
    );
    SharedPreferencesUtils.getUserDataFromSharedPreferences();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Home'),
            ),
            IconButton(
              onPressed: () {
                // Navigate to Profile Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
              icon: const Icon(
                  Icons.account_circle), // Add your profile icon here
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(156, 154, 255, 100),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(44, 44, 70, 0.612),
                  Color.fromARGB(255, 86, 8, 100),
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
                'assets/mountains.jpg',
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 188, 131, 197),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    motivationalMessage,
                    style: const TextStyle(fontSize: 17),
                  ),
                ),
                // Centered Daily Check-In button
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.purple),
                      // You can adjust other properties here, such as text color, padding, etc.
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DailyCheckInForm()),
                      );
                    },
                    child: const Text('Daily Check-In'),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.purple,
              onPressed: () {
                // Handle the theme button click.
              },
              child: const Icon(Icons.brush),
            ),
          ),
        ],
      ),
    );
  }
}
