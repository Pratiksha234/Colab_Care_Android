import 'package:colab_care/controllers/Home_Screen/Mindfullness.dart';
import 'package:colab_care/controllers/Home_Screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyCheckInForm extends StatefulWidget {
  const DailyCheckInForm({Key? key}) : super(key: key);

  @override
  _DailyCheckInFormState createState() => _DailyCheckInFormState();
}

class _DailyCheckInFormState extends State<DailyCheckInForm> {
  String? _feelingToday;
  String? _stressLevel;
  String? _sleepSatisfaction;
  String? _engagingActivities;
  String? _socialRelationships;
  String? _medicationTaken;

  List<String> feelings = [
    'Happy',
    'Motivated',
    'Calm',
    'Blah',
    'Sad',
    'Stressed',
    'Angry'
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 168, 130, 174),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
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
                style: TextStyle(
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
      print('Form submitted with values:');
      print('Feeling Today: $_feelingToday');
      print('Stress Level: $_stressLevel');
      print('Sleep Satisfaction: $_sleepSatisfaction');
      print('Engaging Activities: $_engagingActivities');
      print('Social Relationships: $_socialRelationships');
      print('Medication Taken: $_medicationTaken');

      final currentDate = DateFormat('yyyyMMdd').format(DateTime.now());

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
        // Navigate to screen with suggestions
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuggestedExercisesScreen(),
          ),
        );
      } else {
        // Navigate to screen with no suggestions
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoSuggestionsScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Check-In Form'),
        backgroundColor: Color.fromARGB(255, 161, 127, 167),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '1. How are you feeling today? *',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              buildDropdown(feelings, _feelingToday, (value) {
                setState(() {
                  _feelingToday = value;
                });
              }),
              const Text(
                '2. I have been feeling stressed and nervous. *',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              buildDropdown(stressLevels, _stressLevel, (value) {
                setState(() {
                  _stressLevel = value;
                });
              }),
              const Text(
                '3. I have been satisfied with my sleep. *',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              buildDropdown(sleepSatisfaction, _sleepSatisfaction, (value) {
                setState(() {
                  _sleepSatisfaction = value;
                });
              }),
              const Text(
                '4. I have been engaging in activities I enjoy. *',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              buildDropdown(engagingActivities, _engagingActivities, (value) {
                setState(() {
                  _engagingActivities = value;
                });
              }),
              const Text(
                '5. My social relationships have been supportive and rewarding. *',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              buildDropdown(socialRelationships, _socialRelationships, (value) {
                setState(() {
                  _socialRelationships = value;
                });
              }),
              const Text(
                '6. Did you take your medication yesterday? *',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              buildDropdown(medicationTaken, _medicationTaken, (value) {
                setState(() {
                  _medicationTaken = value;
                });
              }),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isFormValid() ? submitForm : null,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  primary: isFormValid()
                      ? Colors.purple
                      : Colors.grey, // Disable button color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuggestedExercisesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suggestions'),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 172, 131, 180),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Based on all of your responses to the daily check-in questions, we recommend you visit the mindfulness tab to listen to different exercises that may provide strategies to manage your feelings,thoughts and stress. ',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the home page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: Text('Close'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}

class NoSuggestionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suggestions'),
        backgroundColor: Color.fromARGB(255, 93, 56, 100),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No suggestions at this moment, thank you for answering the daily check-in form. Have a great day!',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text('Go to Home'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// currentUserEmail is a simulated value; replace it with your actual logic.
String currentUserEmail = 'example@example.com';
