import 'package:colab_care/widgets/custom_appbar.dart';
import 'package:colab_care/exports.dart';
import 'package:intl/intl.dart';

class EditGoalScreen extends StatefulWidget {
  const EditGoalScreen({super.key, required this.goal});

  final Goal goal;

  @override
  State<EditGoalScreen> createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  late TextEditingController progressController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    progressController = TextEditingController(text: widget.goal.progress);
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      appBar: const CustomAppbar(appBarTitle: "Edit Goals"),
      backgroundColor: theme.backgroundGradientStart,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Update Goal Progress',
              style: theme.headerFont,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: progressController,
              decoration: InputDecoration(
                labelText: 'New Progress',
                floatingLabelStyle: TextStyle(color: theme.textColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.borderColor),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.borderColor),
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Text(
                  'Update goal completed date',
                  style: theme.headerFont,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 5),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  icon: Icon(
                    Icons.calendar_today,
                    color: theme.tabBarBackgroundColor,
                    size: 35.0,
                  ),
                ),
              ],
            ),
            Text(
              '${_formatDate(_selectedDate)}  ',
              style: theme.headerFont,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                var updatedGoal = Goal(
                    id: widget.goal.id,
                    title: widget.goal.title,
                    desc: widget.goal.desc,
                    progress: progressController.text,
                    dueDate: _formatDate(_selectedDate),
                    createdDate: widget.goal.createdDate,
                    completed: widget.goal.completed);

                // Call updateGoal from GoalsProvider with new values
                Provider.of<GoalsProvider>(context, listen: false)
                    .updateGoal(updatedGoal);
                Navigator.pop(context);
              },
              child: const Text("Update Goal"),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('MMM d, yyyy').format(dateTime);
  }
}
