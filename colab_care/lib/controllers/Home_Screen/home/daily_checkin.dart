import 'package:colab_care/controllers/Home_Screen/home/tab_bar.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:colab_care/database_access.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyCheckInForm extends StatefulWidget {
  const DailyCheckInForm({super.key});

  @override
  State<DailyCheckInForm> createState() {
    return _DailyCheckInFormState();
  }
}

class _DailyCheckInFormState extends State<DailyCheckInForm> {
  String? _feelingToday;
  String? _stressLevel;
  String? _sleepSatisfaction;
  String? _engagingActivities;
  String? _socialRelationships;
  String? _medicationTaken;
  String currentUserEmail = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserEmail = prefs.getString('email') ?? '';
  }

  List<String> feelings = [
    'Happy 😁',
    'Motivated 🤩',
    'Calm 🙂',
    'Blah 🫠',
    'Sad 😔',
    'Stressed 😖',
    'Angry 😡'
  ];
  List<String> stressLevels = [
    'Always',
    'Often',
    'Sometimes',
    'Rarely',
    'Never'
  ];
  List<String> sleepSatisfaction = [
    'Always',
    'Often',
    'Sometimes',
    'Rarely',
    'Never'
  ];
  List<String> engagingActivities = [
    'Always',
    'Often',
    'Sometimes',
    'Rarely',
    'Never'
  ];
  List<String> socialRelationships = [
    'Always',
    'Often',
    'Sometimes',
    'Rarely',
    'Never'
  ];
  List<String> medicationTaken = [
    'I do not take any medication',
    'I took all of my medication',
    'I did not take any of my medication',
    'I took some of my medication'
  ];

  bool isFormValid() {
    return _feelingToday != null &&
        _stressLevel != null &&
        _sleepSatisfaction != null &&
        _engagingActivities != null &&
        _socialRelationships != null &&
        _medicationTaken != null;
  }

  Widget buildDropdown(List<String> items, String? selectedItem,
      void Function(String?) onChanged) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: theme.tabBarBackgroundColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedItem,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void submitForm() {
    if (isFormValid()) {
      // print('Form submitted with values:');
      // print('Feeling Today: $_feelingToday');
      // print('Stress Level: $_stressLevel');
      // print('Sleep Satisfaction: $_sleepSatisfaction');
      // print('Engaging Activities: $_engagingActivities');
      // print('Social Relationships: $_socialRelationships');
      // print('Medication Taken: $_medicationTaken');

      final currentDate = DateFormat('yyyyMMdd').format(DateTime.now());
      currentUserEmail =
          DatabaseUtils.convertToHyphenSeparatedEmail(currentUserEmail);
      // print(currentUserEmail);
      // Firebase Database reference
      DatabaseReference databaseReference = FirebaseDatabase.instance
          .ref()
          .child('patient_data')
          .child(currentUserEmail)
          .child('dailycheckin')
          .child(currentDate);

      databaseReference.set({
        '1': _feelingToday,
        '2': _stressLevel,
        '3': _sleepSatisfaction,
        '4': _engagingActivities,
        '5': _socialRelationships,
        '6': _medicationTaken,
        'date': DateFormat('MMM dd, yyyy').format(DateTime.now()),
      });

      if (_feelingToday == 'Blah' ||
          _feelingToday == 'Sad' ||
          _feelingToday == 'Stressed' ||
          _feelingToday == 'Angry' ||
          _stressLevel == 'Always' ||
          _stressLevel == 'Often' ||
          _stressLevel == 'Sometimes' ||
          _sleepSatisfaction == 'Sometimes' ||
          _sleepSatisfaction == 'Rarely' ||
          _sleepSatisfaction == 'Never' ||
          _engagingActivities == 'Sometimes' ||
          _engagingActivities == 'Rarely' ||
          _engagingActivities == 'Never' ||
          _socialRelationships == 'Sometimes' ||
          _socialRelationships == 'Rarely' ||
          _socialRelationships == 'Never') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SuggestedExercisesScreen(),
          ),
        );
      } else {
        // Navigate to screen with no suggestions
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NoSuggestionsScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Daily Check-In'),
        ),
        backgroundColor: theme.tabBarBackgroundColor,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
        centerTitle: false,
      ),
      backgroundColor: theme.backgroundColor,
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '1. How are you feeling today?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              buildDropdown(feelings, _feelingToday, (value) {
                setState(() {
                  _feelingToday = value;
                });
              }),
              const Text(
                '2. I have been feeling stressed and nervous.',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              buildDropdown(stressLevels, _stressLevel, (value) {
                setState(() {
                  _stressLevel = value;
                });
              }),
              const Text(
                '3. I have been satisfied with my sleep.',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              buildDropdown(sleepSatisfaction, _sleepSatisfaction, (value) {
                setState(() {
                  _sleepSatisfaction = value;
                });
              }),
              const Text(
                '4. I have been engaging in activities I enjoy.',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              buildDropdown(engagingActivities, _engagingActivities, (value) {
                setState(() {
                  _engagingActivities = value;
                });
              }),
              const Text(
                '5. My social relationships have been supportive and rewarding.',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              buildDropdown(socialRelationships, _socialRelationships, (value) {
                setState(() {
                  _socialRelationships = value;
                });
              }),
              const Text(
                '6. Did you take your medication yesterday?',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              buildDropdown(medicationTaken, _medicationTaken, (value) {
                setState(() {
                  _medicationTaken = value;
                });
              }),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isFormValid() ? submitForm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormValid()
                      ? theme.tabBarBackgroundColor
                      : theme.buttonTintColor, // Disable button color
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

class SuggestedExercisesScreen extends StatelessWidget {
  const SuggestedExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggestions'),
        automaticallyImplyLeading: false,
        backgroundColor: theme.backgroundColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Based on all of your responses to the daily check-in questions, we recommend you visit the mindfulness tab to listen to different exercises that may provide strategies to manage your feelings,thoughts and stress. ',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the home page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TabBarScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Close'),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}

class NoSuggestionsScreen extends StatelessWidget {
  const NoSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggestions'),
        backgroundColor: const Color.fromARGB(255, 93, 56, 100),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'No suggestions at this moment, thank you for answering the daily check-in form. Have a great day!',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TabBarScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
