import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class Reminder {
  late int id;

  late String name;
  late double dosage;
  late DateTime dateTime;
  late String medicineType;
  late bool isDaily;
  late String medicineUnit;

  Reminder({
    required this.id,
    required this.name,
    required this.dosage,
    required this.dateTime,
    required this.medicineType,
    required this.isDaily,
    required this.medicineUnit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'dateTime': dateTime.toIso8601String(),
      'medicineType': medicineType,
      'isDaily': isDaily,
      'medicineUnit': medicineUnit,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      dateTime: DateTime.parse(map['dateTime']),
      medicineType: map['medicineType'],
      isDaily: map['isDaily'],
      medicineUnit: map['medicineUnit'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Reminder.fromJson(String source) =>
      Reminder.fromMap(json.decode(source));
}

class RemindersProvider extends ChangeNotifier {
  List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  Future<void> saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersList =
        reminders.map((reminder) => reminder.toJson()).toList();
    await prefs.setString('reminders', jsonEncode(remindersList));
  }

  Future<void> loadRemindersFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final remindersList = prefs.getStringList('reminders');
    if (remindersList != null) {
      _reminders =
          remindersList.map((json) => Reminder.fromJson(json)).toList();
      notifyListeners();
    }
  }

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    saveReminders(); // Save reminders whenever a new one is added
    notifyListeners();
  }

  void deleteReminder(Reminder reminder) async {
    _reminders.remove(reminder);
    saveReminders(); // Save reminders after deletion
    await AwesomeNotifications()
        .cancel(reminder.id); // Cancel associated notification
    notifyListeners();
  }

  void resetMedicationReminders() async {
    _reminders.clear();
    saveReminders(); // Save empty list to clear stored reminders
    notifyListeners();
  }
}
