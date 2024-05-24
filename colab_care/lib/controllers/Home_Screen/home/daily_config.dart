import 'package:colab_care/controllers/Home_Screen/reminders/reminder_provider.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:provider/provider.dart';

class DailyCheckInConfigScreen extends StatefulWidget {
  @override
  _DailyCheckInConfigScreenState createState() =>
      _DailyCheckInConfigScreenState();
}

class _DailyCheckInConfigScreenState extends State<DailyCheckInConfigScreen> {
  late DateTime _selectedTime;

  @override
  void initState() {
    initializeNotificationChannels();
    super.initState();
    _selectedTime = DateTime.now();
  }

  void initializeNotificationChannels() {
    AwesomeNotifications().initialize(
      'resource://drawable/act',
      [
        NotificationChannel(
          channelKey: 'daily_check_in_channel',
          channelName: 'Daily Check-In Channel',
          channelDescription: 'Channel for daily check-in notifications',
          defaultColor: const Color(0xFF9C27B0),
          ledColor: Colors.white,
        ),
      ],
    );
  }

  int count = 400;
  void _addDailyCheckInReminder(BuildContext context) async {
    final now = DateTime.now();
    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // Create daily notification
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: count,
        channelKey: 'daily_check_in_channel', // Use your channel key here
        title: 'Complete Your Daily Check-in',
        body: 'Don\'t forget to complete your daily check-in!',
        // Set a valid small icon
      ),
      schedule: NotificationCalendar(
        hour: selectedDateTime.hour,
        minute: selectedDateTime.minute,
        allowWhileIdle: true,
        repeats: true, // Repeat daily
      ),
    );

    Navigator.pop(context); // Close the add reminder screen
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      backgroundColor: theme.backgroundGradientStart,
      appBar: AppBar(
        title: const Text('Configure Daily Check-In Time'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Select Time for Daily Check-In:',
              style: theme.headerFont,
            ),
            const SizedBox(height: 20),
            TimePickerSpinner(
              is24HourMode: false,
              normalTextStyle: TextStyle(fontSize: 24, color: Colors.black),
              highlightedTextStyle:
                  TextStyle(fontSize: 24, color: theme.buttonTintColor),
              spacing: 50,
              itemHeight: 80,
              isForce2Digits: true,
              onTimeChange: (time) {
                setState(() {
                  _selectedTime = time;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addDailyCheckInReminder(
                  context), // Wrap the method call in a lambda function
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
