import 'package:colab_care/exports.dart';

import 'package:intl/intl.dart';

class AddMilestoneScreen extends StatefulWidget {
  final String goalId;

  const AddMilestoneScreen(String id, {Key? key, required this.goalId})
      : super(key: key);

  @override
  _AddMilestoneScreenState createState() => _AddMilestoneScreenState();
}

class _AddMilestoneScreenState extends State<AddMilestoneScreen> {
  final TextEditingController _milestoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Milestone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Goal ID: ${widget.goalId}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _milestoneController,
              decoration: const InputDecoration(
                labelText: 'Milestone',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                String currentUserEmail = prefs.getString('email') ?? '';
                currentUserEmail = DatabaseUtils.convertToHyphenSeparatedEmail(
                    currentUserEmail);
                final currentDate =
                    DateFormat('yyyyMMdd').format(DateTime.now());

                final DatabaseReference goalsRef = FirebaseDatabase.instance
                    .reference()
                    .child('patient_data')
                    .child(currentUserEmail)
                    .child('goals')
                    .child(widget
                        .goalId) // Assuming widget.goalId is the goal ID for which the milestone is being added
                    .child('milestones')
                    .child(currentDate);
                String milestoneText = _milestoneController.text;
                goalsRef.set({
                  'milestone': milestoneText,
                  'date': ServerValue.timestamp,
                });

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _milestoneController.dispose();
    super.dispose();
  }
}
