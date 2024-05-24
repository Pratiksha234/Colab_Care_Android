import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colab_care/controllers/Home_Screen/reminders/add_reminder.dart';
import 'package:colab_care/controllers/Home_Screen/reminders/reminder_provider.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({Key? key}) : super(key: key);

  @override
  _MedicationScreenState createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  late RemindersProvider remindersProvider;

  @override
  void initState() {
    super.initState();
    loadReminders();
  }

  void loadReminders() async {
    remindersProvider = Provider.of<RemindersProvider>(context, listen: false);
    await remindersProvider.loadRemindersFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final remindersProvider = Provider.of<RemindersProvider>(context);
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Scaffold(
      backgroundColor: theme.backgroundGradientStart,
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Medication',
            style: theme.navbarFont,
          ),
        ),
        backgroundColor: theme.backgroundGradientStart,
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: ListView.builder(
        itemCount: remindersProvider.reminders.length,
        itemBuilder: (context, index) {
          final reminder = remindersProvider.reminders[index];
          return LongPressDraggable(
            hapticFeedbackOnStart: true,
            onDragStarted: () {
              // Optional: handle drag started event
            },
            onDragEnd: (details) {
              // Optional: handle drag end event
            },
            feedback: Material(
              color: theme.backgroundColor,
              elevation: 5.0,
              child: ListTile(
                title: Text(reminder.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dosage ${reminder.dosage} ${reminder.medicineUnit} ',
                      style: theme.textFont,
                    ),
                  ],
                ),
                trailing: Text(
                  'Time: ${_formatTime(reminder.dateTime)}',
                  style: theme.textFont,
                ),
                leading: Image.asset(
                  getMedicineImage(reminder.medicineType),
                  height: 60,
                  width: 60,
                ),
              ),
            ),
            childWhenDragging: Container(), // Placeholder when dragging
            data: index,
            child: Card(
              elevation: 3,
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  reminder.name,
                  style: theme.headerFont,
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dosage ${reminder.dosage} ${reminder.medicineType}',
                          style: theme.textFont,
                        ),
                        Text(
                          'Time: ${_formatTime(reminder.dateTime)}',
                          style: theme.textFont,
                        ),
                      ],
                    ),
                    SizedBox(width: 60), // Adjust the width as needed
                  ],
                ),
                leading: Image.asset(
                  getMedicineImage(reminder.medicineType),
                  height: 60,
                  width: 60,
                ),
                onLongPress: () {
                  _showEditBottomSheet(context, reminder);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'Add Reminder',
        backgroundColor: theme.buttonTintColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddReminderScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String getMedicineImage(String type) {
    if (type == 'Pill') {
      return 'assets/pill.png';
    } else if (type == 'Tablet') {
      return 'assets/pill.png';
    } else if (type == 'Syrup') {
      return 'assets/syrup.png';
    } else if (type == 'Vitamin') {
      return 'assets/vitamins.png';
    } else {
      return 'assets/pill.png';
    }
  }

  void _showEditBottomSheet(BuildContext context, Reminder reminder) {
    TextEditingController dosageController = TextEditingController();
    dosageController.text = reminder.dosage.toString();

    DateTime selectedTime = reminder.dateTime;

    bool isDaily = reminder.isDaily;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Edit Reminder',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: dosageController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Update Dosage'),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Update Time: ${_formatTime(selectedTime)}'),
                      IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: selectedTime.hour,
                              minute: selectedTime.minute,
                            ),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              selectedTime = DateTime(
                                selectedTime.year,
                                selectedTime.month,
                                selectedTime.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Update Daily Prescription'),
                      Switch(
                        value: isDaily,
                        onChanged: (value) {
                          setState(() {
                            isDaily = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Update reminder with the new values
                      reminder.dosage = double.parse(dosageController.text);
                      reminder.dateTime = selectedTime;
                      reminder.isDaily = isDaily;

                      // Update notification with new time and daily prescription status
                      AwesomeNotifications().createNotification(
                        content: NotificationContent(
                          id: reminder.id,
                          channelKey: 'basic_channel',
                          title: 'Medication Reminder - ${reminder.name}',
                          body:
                              'Time to take your ${reminder.medicineType} named ${reminder.name}.',
                        ),
                        schedule: isDaily
                            ? NotificationCalendar(
                                weekday: selectedTime.weekday,
                                hour: selectedTime.hour,
                                minute: selectedTime.minute,
                                allowWhileIdle: true,
                              )
                            : NotificationCalendar(
                                weekday: selectedTime.weekday,
                                hour: selectedTime.hour,
                                minute: selectedTime.minute,
                                allowWhileIdle: true,
                                repeats: false,
                              ),
                      );

                      // Update the reminder list
                      Provider.of<RemindersProvider>(context, listen: false)
                          .notifyListeners();

                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: const Text('Update'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Cancel notification and delete reminder
                      AwesomeNotifications().cancel(reminder.id);
                      Provider.of<RemindersProvider>(context, listen: false)
                          .deleteReminder(reminder);
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
