import 'package:colab_care/models/realm_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colab_care/controllers/Home_Screen/reminder_provider.dart';

class AddReminderScreen extends StatefulWidget {
  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  bool _isDaily = false;
  String _medicineType = 'Pill';

  @override
  Widget build(BuildContext context) {
    final remindersProvider = Provider.of<RemindersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Reminder'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Medicine Name"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _dosageController,
              decoration: InputDecoration(labelText: 'Dosage'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a dosage';
                }
                return null;
              },
            ),
            ListTile(
              title: Text('Take Daily?'),
              trailing: Switch(
                value: _isDaily,
                onChanged: (value) {
                  setState(() {
                    _isDaily = value;
                  });
                },
              ),
            ),
            Text(
              'Select Type of Medicine',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8.0,
              children: ['Pill', 'Tablet', 'Syrup', 'Vitamin'].map((type) {
                return ChoiceChip(
                  label: Text(type),
                  selected: _medicineType == type,
                  onSelected: (selected) {
                    setState(() {
                      _medicineType = type;
                    });
                  },
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newReminder = Reminder(
                    name: _nameController.text,
                    dosage: _dosageController.text,
                    dateTime: DateTime.now(),
                    isDaily: _isDaily,
                    medicineType: _medicineType,
                  );
                  remindersProvider.addReminder(newReminder);
                  Navigator.pop(context);
                }
              },
              child: Text('Save Reminder'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }
}
