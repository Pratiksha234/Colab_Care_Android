import 'package:colab_care/controllers/Themes/theme_manager.dart';
// import 'package:colab_care/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';
import 'package:colab_care/controllers/Home_Screen/reminders/reminder_provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() {
    return _AddReminderScreenState();
  }
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final TextEditingController _nameController = TextEditingController();
  double _selectedDosage = 1.0; // Default dosage
  late TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isDaily = true; // Default value for daily prescription
  String _selectedType = 'Pill'; // Default type
  String _selectedUnit = '';
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final Map<String, String> _medicineTypeToUnit = {
    'Pill': 'pill',
    'Tablet': 'tablet',
    'Syrup': 'ml',
    'Vitamin': 'unit',
  };
  List<String> _reminders = [];

  @override
  void initState() {
    super.initState();
    // _loadReminders();
    _initializeLocalNotifications(); // Load reminders from shared preferences
  }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _reminders = prefs.getStringList('reminders') ?? [];
    });
  }

  void _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Container(
      color: theme.backgroundGradientStart, // Set the background color here
      child: Scaffold(
        backgroundColor: theme.backgroundGradientStart,
        appBar: AppBar(
          backgroundColor: theme.backgroundGradientStart,
          toolbarHeight: 100.0,
          title: Text(
            'Add Medicine',
            style: theme.navbarFont,
          ),
          // automaticallyImplyLeading: false,
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            // Wrap Column with SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What\'s the medicine name?',
                    style: theme.headerFont,
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelStyle: theme.captionFont,
                      labelText: 'Enter your medicine name here',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: theme.borderColor), // Set border color here
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: theme.borderColor), // Set border color here
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Add Dosage ',
                    style: theme.headerFont,
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _selectedDosage = double.tryParse(value) ?? 0.0;
                      });
                    },
                    decoration: InputDecoration(
                      labelStyle: theme.captionFont,
                      labelText: 'Add your medicine dosage detail',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: theme.borderColor), // Set border color here
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: theme.borderColor), // Set border color here
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'When do you take it?',
                    style: theme.headerFont,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Current Reminder Time: ${_selectedTime.format(context)}',
                          style: theme.textFont,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                              builder: (BuildContext context, Widget? child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                    alwaysUse24HourFormat: false,
                                  ),
                                  child: Theme(
                                    // Set colors for the clock to theme colors
                                    data: ThemeData(
                                      primaryColor: theme
                                          .buttonTintColor, // Set clock hands color
                                      // backgroundColor: theme
                                      //     .backgroundGradientStart, // Set clock background color
                                    ),
                                    child: child!,
                                  ),
                                );
                              });
                          if (pickedTime != null) {
                            setState(() {
                              _selectedTime = pickedTime;
                            });
                          }
                        },
                        child: Text('Change Time',
                            style: theme
                                .headerFont), // Set text color to theme.headerFont
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Text(
                        'Is this a Daily Prescription?',
                        style: theme.headerFont,
                      ),
                      Switch(
                        value: _isDaily,
                        activeColor: theme.buttonTintColor,
                        inactiveTrackColor: theme.tabBarSelectedItemColor,
                        onChanged: (value) {
                          setState(() {
                            _isDaily = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Medicine Type',
                    style: theme.headerFont,
                  ),
                  GroupButton<String>(
                    options: GroupButtonOptions(
                        selectedColor: theme.buttonTintColor),
                    buttons: const ['Pill', 'Tablet', 'Syrup', 'Vitamin'],
                    isRadio: true,
                    onSelected: (selected, index, isSelected) {
                      setState(() {
                        _selectedType = selected;
                        _selectedUnit =
                            _medicineTypeToUnit[_selectedType] ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      _addReminder(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          theme.buttonTintColor),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            horizontal: 3.0), // Add padding to the sides
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(double.infinity,
                            40), // Set minimum size to fill width
                      ),
                    ),
                    child: const Text('Save Reminder',
                        style: TextStyle(
                            color:
                                Colors.white)), // Adjust text color as needed
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _idCounter = 0;
  void _addReminder(BuildContext context) async {
    if (_nameController.text.isNotEmpty) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      final uniqueId = _idCounter++; // Increment counter to generate unique ID

      // Calculate time difference between now and selected time
      final timeDifference = selectedDateTime.difference(now);

      // Create a Reminder object
      final newReminder = Reminder(
        name: _nameController.text,
        dosage: _selectedDosage,
        dateTime: selectedDateTime,
        medicineType: _selectedType,
        isDaily: _isDaily,
        id: uniqueId,
        medicineUnit: _selectedUnit,
      );
      final reminderProvider =
          Provider.of<RemindersProvider>(context, listen: false);

      // Add the new reminder
      reminderProvider.addReminder(newReminder);

      // Create notification based on daily or one-time
      if (_isDaily) {
        // For daily notifications, schedule every 24 hours
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: uniqueId,
            channelKey: 'basic_channel',
            title: 'Medication Reminder - ${_nameController.text}',
            body:
                'Time to take your $_selectedType named ${_nameController.text}.',
            payload: {
              'appName': 'Collaborative Care', // Set your app's name here
            },
          ),
          schedule: NotificationCalendar(
            weekday: selectedDateTime.weekday,
            hour: selectedDateTime.hour,
            minute: selectedDateTime.minute,
            allowWhileIdle: true,
          ),
        );
      } else {
        // For non-daily notifications, schedule only once
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: uniqueId,
            channelKey: 'basic_channel',
            title: 'Medication Reminder - ${_nameController.text}',
            body:
                'Time to take your $_selectedType named ${_nameController.text}.',
          ),
          schedule: NotificationCalendar(
            weekday: selectedDateTime.weekday,
            hour: selectedDateTime.hour,
            minute: selectedDateTime.minute,
            allowWhileIdle: true,
            repeats: false,
          ),
        );
      }

      Navigator.pop(context); // Close the add reminder screen
    }
  }
}
