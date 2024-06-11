import 'package:colab_care/controllers/Home_Screen/goals/edit_goal.dart';
import 'package:colab_care/widgets/custom_main_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  // To open modal sheet to add new goals
  void _openGoalsOverlay(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (ctx) => const AddGoalScreen(),
    );
  }

  // To open modal sheet to edit an existing goal.
  void _openEditGoalsOverlay(BuildContext context, Goal goal) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (ctx) => EditGoalScreen(
        goal: goal,
      ),
    );
  }

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
          child: Text(
            "Active",
          ),
        ),
        1: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Completed",
          ),
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
      appBar: const CustomMainAppbar(appBarTitle: "Goals"),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.backgroundGradientStop,
                  theme.backgroundGradientStart,
                ],
              ),
            ),
          ),
          Column(
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
                        elevation: 8.0,
                        color: theme.backgroundGradientStart,
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  _openEditGoalsOverlay(context, goal);
                                },
                                backgroundColor: theme.tabBarBackgroundColor,
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
                            title: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                goal.title,
                                style: theme.headerFont,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description: ${goal.desc}',
                                  style: theme.captionFont,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Progress: ${goal.progress}',
                                  style: theme.captionFont,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Due Date: ${goal.dueDate}',
                                  style: theme.captionFont,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Created Date: ${goal.createdDate}',
                                  style: theme.captionFont,
                                ),
                              ],
                            ),
                            trailing: InkWell(
                              onTap: () {
                                if (!goal.completed) {
                                  _confirmCompleteGoal(
                                      context, goal.id, !goal.completed);
                                }
                              },
                              child: goal.completed
                                  ? Icon(
                                      Icons.check_circle,
                                      color: theme.tabBarBackgroundColor,
                                      size: 39,
                                    )
                                  : Icon(
                                      Icons.circle_outlined,
                                      color: theme.tabBarBackgroundColor,
                                      size: 39,
                                    ),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'Add Goal',
        backgroundColor: theme.buttonTintColor,
        onPressed: () {
          _openGoalsOverlay(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
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

              var updatedGoal = Goal(
                  id: goalId,
                  title: currentGoal.title,
                  desc: currentGoal.desc,
                  progress: 'Completed',
                  dueDate: currentGoal.dueDate,
                  createdDate: currentGoal.createdDate,
                  completed: value);

              // Call a method to update the goal as completed
              Provider.of<GoalsProvider>(context, listen: false).updateGoal(
                updatedGoal,
              );
            },
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }
}
