import 'package:colab_care/exports.dart';
import 'package:colab_care/widgets/custom_appbar.dart';

import 'package:intl/intl.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() {
    return _AddGoalScreenState();
  }
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
      appBar: const CustomAppbar(appBarTitle: "Add Goal"),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                const SizedBox(height: 30.0),
                Row(
                  children: [
                    Text(
                      'When do you want to achieve it ?  ',
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
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
                Text(
                  '${_formatDate(_selectedDate)}  ',
                  style: theme.headerFont,
                ),
                const SizedBox(height: 25.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.tabBarBackgroundColor),
                  onPressed: () {
                    final title = _titleController.text.trim();
                    final description = _descriptionController.text.trim();
                    if (title.isNotEmpty && description.isNotEmpty) {
                      var newGoal = Goal(
                          id: "id",
                          title: title,
                          desc: description,
                          progress: "Progress: ⏳",
                          dueDate: _formatDate(_selectedDate),
                          createdDate: _formatDate(DateTime.now()),
                          completed: false);

                      Provider.of<GoalsProvider>(context, listen: false)
                          .addGoal(newGoal);

                      fetchGoals();

                      Navigator.pop(context);
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
                  child: const Text(
                    'Save Goal',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
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
