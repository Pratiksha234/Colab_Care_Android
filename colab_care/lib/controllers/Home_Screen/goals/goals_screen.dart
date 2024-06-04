import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

import 'package:colab_care/controllers/Home_Screen/goals/add_goal.dart';

// import 'package:colab_care/database_access.dart';
import 'package:colab_care/models/goal_model.dart'; // Ensure you have a Goal model
import 'package:colab_care/exports.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() {
    return _GoalsScreenState();
  }
}

class _GoalsScreenState extends State<GoalsScreen> {
  int _segmentedControlValue = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<GoalsProvider>(context, listen: false).fetchGoalsOnce();
  }

  Widget buildSegmentedControl() {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return CupertinoSegmentedControl<int>(
      padding: const EdgeInsets.all(8),
      children: const {
        0: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text("Active"),
        ),
        1: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text("Completed"),
        ),
      },
      onValueChanged: (int value) {
        setState(() {
          _segmentedControlValue = value;
        });
      },
      groupValue: _segmentedControlValue,
      selectedColor:
          theme.buttonTintColor, // Color when the segment is selected
      unselectedColor: Colors.white, // Color when the segment is not selected
      borderColor: theme.buttonTintColor, // Border color of the segments
    );
  }

  @override
  Widget build(BuildContext context) {
    final goalsProvider = Provider.of<GoalsProvider>(context);
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    List<Goal> filteredGoals = _segmentedControlValue == 0
        ? goalsProvider.goals.where((g) => !g.completed).toList()
        : goalsProvider.goals.where((g) => g.completed).toList();

    return Scaffold(
      backgroundColor: theme.backgroundGradientStart,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Goals',
            style: theme.navbarFont,
          ),
        ),
        backgroundColor: theme.backgroundGradientStart,
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          buildSegmentedControl(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Provider.of<GoalsProvider>(context, listen: false)
                    .fetchGoalsOnce();
              },
              child: ListView.builder(
                itemCount: filteredGoals.length,
                itemBuilder: (context, index) {
                  final goal = filteredGoals[index];
                  return Card(
                    color: theme.backgroundGradientStop,
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) => _editGoal(context, goal),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (context) =>
                                _deleteGoal(context, goal.id),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(goal.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description: ${goal.desc}'),
                            Text('Progress: ${goal.progress}'),
                            Text('Due Date: ${goal.dueDate}'),
                            Text('Created Date: ${goal.createdDate}'),
                          ],
                        ),
                        trailing: ToggleButtons(
                          borderColor:
                              Colors.transparent, // Removing default border
                          fillColor:
                              theme.buttonTintColor, // Fill color when selected
                          selectedBorderColor:
                              Colors.transparent, // Remove border on selection
                          renderBorder: false, // Don't render the border
                          isSelected: [goal.completed],
                          onPressed: (index) {
                            _confirmCompleteGoal(
                                context, goal.id, !goal.completed);
                          },
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape
                                    .circle, // Making the container circular
                                color: goal.completed
                                    ? theme.buttonTintColor
                                    : Colors.grey[
                                        300], // Change color based on completion
                              ),
                              padding: const EdgeInsets.all(
                                  8), // Padding to make the circle larger
                              child: Icon(
                                goal.completed
                                    ? Icons.check
                                    : Icons.radio_button_unchecked,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'Add Goal',
        backgroundColor: theme.buttonTintColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddGoalScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _editGoal(BuildContext context, Goal goal) {
    final progressController = TextEditingController(text: goal.progress);
    DateTime? selectedDueDate = DateTime.tryParse(goal.dueDate);

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              children: <Widget>[
                TextField(
                  controller: progressController,
                  decoration: const InputDecoration(
                    labelText: "Update Goal Progress",
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: Text(
                      "Due Date: ${selectedDueDate != null ? DateFormat('yyyy-MM-dd').format(selectedDueDate!) : 'Not set'}"),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDueDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2025),
                    );
                    if (picked != null && picked != selectedDueDate) {
                      setState(() {
                        selectedDueDate = picked;
                      });
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedDueDate != null) {
                      // Call updateGoal from GoalsProvider with new values
                      Provider.of<GoalsProvider>(context, listen: false)
                          .updateGoal(
                        context,
                        id: goal.id,
                        title: goal.title, // Keep existing title
                        desc: goal.desc, // Keep existing description
                        progress: progressController.text,
                        dueDate: selectedDueDate!
                            .toIso8601String(), // Format as needed
                        createdDate: goal.createdDate,
                        completed: goal.completed,
                      );

                      // Close the BottomSheet
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Update Goal"),
                ),
              ],
            ),
          );
        });
  }

  void _deleteGoal(BuildContext context, String goalId) {
    Provider.of<GoalsProvider>(context, listen: false).deleteGoal(goalId);
  }

  void _confirmCompleteGoal(BuildContext context, String goalId, bool value) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Goal'),
        content: const Text('Are you sure you want to complete this goal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Retrieve the goal details before updating
              var currentGoal =
                  Provider.of<GoalsProvider>(context, listen: false)
                      .goals
                      .firstWhere((goal) => goal.id == goalId);

              // Call a method to update the goal as completed
              Provider.of<GoalsProvider>(context, listen: false).updateGoal(
                  context,
                  id: goalId,
                  title: currentGoal.title, // Keep existing title
                  desc: currentGoal.desc, // Keep existing description
                  progress: 'Completed', // Update progress to "Completed"
                  dueDate: currentGoal.dueDate, // Keep existing due date
                  createdDate:
                      currentGoal.createdDate, // Keep existing created date
                  completed: value // Update completed status
                  );
            },
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }
}
