import 'package:colab_care/models/realm_model.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

class RemindersProvider extends ChangeNotifier {
  final List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    notifyListeners();
  }

  void deleteReminder(Reminder reminder) {
    _reminders.remove(reminder);
    notifyListeners();
  }
}
