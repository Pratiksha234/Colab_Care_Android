import 'package:colab_care/controllers/Home_Screen/add_reminder.dart';
import 'package:colab_care/controllers/Home_Screen/reminder_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final remindersProvider = Provider.of<RemindersProvider>(context);
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: ListView.builder(
        itemCount: remindersProvider.reminders.length,
        itemBuilder: (context, index) {
          final reminder = remindersProvider.reminders[index];
          return ListTile(
            title: Text(reminder.name),
            subtitle: Text(reminder.dosage),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                remindersProvider.deleteReminder(reminder);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReminderScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
