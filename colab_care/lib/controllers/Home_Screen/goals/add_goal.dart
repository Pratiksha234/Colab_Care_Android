import 'package:colab_care/exports.dart';

import 'package:intl/intl.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({Key? key}) : super(key: key);

  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late DateTime _selectedDate = DateTime.now();
  String currentUserEmail = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchGoals();
  }

  void fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserEmail = prefs.getString('email') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      backgroundColor: theme.backgroundGradientStart,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Add Goal',
            style: theme.navbarFont,
          ),
        ),
        backgroundColor: theme.backgroundGradientStart,
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What goal are you working toward?',
              style: theme.headerFont,
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Enter the goal title',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.borderColor),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Text(
              'Add a description about your goal',
              style: theme.headerFont,
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _descriptionController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Add a note about your goal',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.borderColor),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Row(
              children: [
                Text(
                  'When do you want to achieve it ?  ',
                  style: theme.headerFont,
                ),
                const SizedBox(height: 30.0),
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
                  icon: const Icon(Icons.calendar_today),
                ),
              ],
            ),
            Text(
              '${_formatDate(_selectedDate)}  ',
              style: theme.headerFont,
            ),
            const SizedBox(height: 25.0),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  final title = _titleController.text.trim();
                  final description = _descriptionController.text.trim();
                  currentUserEmail =
                      DatabaseUtils.convertToHyphenSeparatedEmail(
                          currentUserEmail);
                  print(currentUserEmail);
                  if (title.isNotEmpty && description.isNotEmpty) {
                    // Add the goal
                    final goalsRef = FirebaseDatabase.instance
                        .reference()
                        .child('patient_data')
                        .child(currentUserEmail)
                        .child('goals')
                        .push(); // Use push() to generate a unique key (goalId)

                    goalsRef.set({
                      'goalId': goalsRef.key,
                      'title': title,
                      'desc': description,
                      'dueDate': "Complete by: ${_formatDate(_selectedDate)}",
                      'createdDate': _formatDate(DateTime.now()),
                      'completed': false,
                      'progress': 'Progress: ⏳'
                      // 'progress': 'Not started', // Initial progress
                    });
                    fetchGoals();

                    Navigator.pop(context); // Close the screen
                  } else {
                    // Show error message if fields are empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all the fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text(
                  'Save Goal',
                  style: theme.headerFont,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchGoals() async {
    final goalsProvider = Provider.of<GoalsProvider>(context, listen: false);
    await goalsProvider.fetchGoalsOnce();
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('MMM d, yyyy').format(dateTime);
  }
}
