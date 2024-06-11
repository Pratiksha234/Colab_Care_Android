import 'package:colab_care/exports.dart';
import 'goals_database_manager.dart';

class GoalsProvider extends ChangeNotifier {
  final List<Goal> _goals = [];
  bool _isFetched = false;

  List<Goal> get goals => _goals;

  final GoalsDatabaseManager _dbManager = GoalsDatabaseManager();

  Future<void> fetchGoalsOnce() async {
    if (!_isFetched) {
      final DatabaseReference goalsRef = await _dbManager.getGoalsRef();

      goalsRef.onValue.listen((DatabaseEvent event) {
        final data = event.snapshot.value;
        Map<dynamic, dynamic>? values = data as Map<dynamic, dynamic>?;
        resetGoals();
        if (values != null) {
          values.forEach((key, value) {
            _goals.add(Goal(
              id: key,
              title: value['title'] ?? '',
              desc: value['desc'] ?? '',
              progress: value['progress'] ?? '',
              dueDate: value['dueDate'] ?? '',
              createdDate: value['createdDate'] ?? '',
              completed: value['completed'] ?? false,
            ));
          });
          _isFetched = true;
          notifyListeners();
        } else {
          // print('No goals found.');
        }
      });
    }
  }

  void resetGoals() {
    _goals.clear();
    _isFetched = false;
    notifyListeners();
  }

  Future<void> addGoal(Goal goal) async {
    final DatabaseReference goalsRef = await _dbManager.getGoalsRef();
    final newGoalRef = goalsRef.push();
    try {
      await newGoalRef.set({
        'goalId': newGoalRef.key,
        'title': goal.title,
        'desc': goal.desc,
        'dueDate': goal.dueDate,
        'createdDate': goal.createdDate,
        'completed': goal.completed,
        'progress': goal.progress,
      });
      notifyListeners();
    } catch (error) {
      // print('Error adding goal: $error');
    }
  }

  Future<void> updateGoal(Goal goal) async {
    final DatabaseReference goalRef = await _dbManager.getGoalRef(goal.id);
    try {
      await goalRef.update({
        'title': goal.title,
        'desc': goal.desc,
        'progress': goal.progress,
        'dueDate': goal.dueDate,
        'createdDate': goal.createdDate,
        'completed': goal.completed,
      });
      int index = _goals.indexWhere((g) => g.id == goal.id);
      if (index != -1) {
        _goals[index] = goal;
        notifyListeners();
      }
    } catch (error) {
      // print('Error updating goal: $error');
    }
  }

  Future<void> deleteGoal(String id) async {
    final DatabaseReference goalRef = await _dbManager.getGoalRef(id);
    try {
      await goalRef.remove();
      _goals.removeWhere((goal) => goal.id == id);
      notifyListeners();
    } catch (error) {
      // print('Error deleting goal: $error');
    }
  }
}
