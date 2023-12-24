import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:colab_care/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming getUserDataFromSharedPreferences is a Future function,
    // you should not call it directly without awaiting it or handling it properly in a FutureBuilder or similar.
    // For the purpose of this example, we are calling it directly, but in a real app, you should handle it asynchronously.
    SharedPreferencesUtils.getUserDataFromSharedPreferences();
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Add Medicine'),
        ),
        backgroundColor: theme.tabBarBackgroundColor,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 28,
        ),
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // TODO: Implement save functionality
            },
          ),
        ],
      ),
      body:
          const AddMedicineForm(), // AddMedicineForm is a StatefulWidget that contains the form
    );
  }
}

class AddMedicineForm extends StatefulWidget {
  const AddMedicineForm({super.key});

  @override
  _AddMedicineFormState createState() => _AddMedicineFormState();
}

class _AddMedicineFormState extends State<AddMedicineForm> {
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isDaily = false;
  String medicineType = 'Pill';

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: "What's the medicine name?",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Add Dosage',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16.0),
        ListTile(
          title: const Text('When do you take it?'),
          subtitle: Text(selectedTime.format(context)),
          onTap: () => _selectTime(context),
        ),
        SwitchListTile(
          title: const Text('Is this a daily prescription?'),
          value: isDaily,
          onChanged: (bool value) {
            setState(() {
              isDaily = value;
            });
          },
        ),
        const SizedBox(height: 16.0),
        const Text(
          'Select type of medicine',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 8.0,
          children: ['Pill', 'Tablet', 'Syrup', 'Vitamin']
              .map((type) => ChoiceChip(
                    label: Text(type),
                    selected: medicineType == type,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          medicineType = type;
                        }
                      });
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}
