import 'package:colab_care/exports.dart';

class GoalsProvider extends ChangeNotifier {
  final List<Goal> _goals = [];
  bool _isFetched = false;

  List<Goal> get goals => _goals;

  Future<void> fetchGoalsOnce() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentUserEmail = prefs.getString('email') ?? '';
    currentUserEmail =
        DatabaseUtils.convertToHyphenSeparatedEmail(currentUserEmail);
    if (!_isFetched && currentUserEmail.isNotEmpty) {
      final DatabaseReference goalsRef = FirebaseDatabase.instance
          // ignore: deprecated_member_use
          .reference()
          .child('patient_data')
          .child(currentUserEmail)
          .child('goals');

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
          print('Goals fetched successfully.');
        } else {
          print('No goals found.');
        }
      });
    }
  }

  void resetGoals() {
    _goals.clear();
    _isFetched = false;
    notifyListeners();
  }

  // Future<void> addGoal(
  //     {required String title,
  //     required String desc,
  //     required String progress,
  //     required String dueDate,
  //     required String createdDate,
  //     required bool completed}) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String currentUserEmail = prefs.getString('email') ?? '';
  //   currentUserEmail =
  //       DatabaseUtils.convertToHyphenSeparatedEmail(currentUserEmail);
  //   final DatabaseReference goalsRef = FirebaseDatabase.instance
  //       .reference()
  //       .child('patient_data')
  //       .child(currentUserEmail)
  //       .child('goals');
  //   try {
  //     // DatabaseReference newGoalRef = goalsRef.push();
  //     // await newGoalRef.set({
  //     //   'title': title,
  //     //   'desc': desc,
  //     //   'progress': progress,
  //     //   'dueDate': dueDate,
  //     //   'createdDate': createdDate,
  //     //   'completed': completed,
  //     // });
  //     // _goals.add(Goal(
  //     //   id: newGoalRef.key!,
  //     //   title: title,
  //     //   desc: desc,
  //     //   progress: progress,
  //     //   dueDate: dueDate,
  //     //   createdDate: createdDate,
  //     //   completed: completed,
  //     // ));
  //     notifyListeners();
  //   } catch (error) {
  //     print('Error adding goal: $error');
  //   }
  // }

  Future<void> updateGoal(BuildContext context,
      {required String id,
      required String title,
      required String desc,
      required String progress,
      required String dueDate,
      required String createdDate,
      required bool completed}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentUserEmail = prefs.getString('email') ?? '';
    currentUserEmail =
        DatabaseUtils.convertToHyphenSeparatedEmail(currentUserEmail);
    final DatabaseReference goalsRef = FirebaseDatabase.instance
        .reference()
        .child('patient_data')
        .child(currentUserEmail)
        .child('goals')
        .child(id);
    try {
      // await goalsRef.update({
      //   'title': title,
      //   'desc': desc,
      //   'progress': progress,
      //   'dueDate': dueDate,
      //   'createdDate': createdDate,
      //   'completed': completed,
      // });
      int index = _goals.indexWhere((goal) => goal.id == id);
      if (index != -1) {
        _goals[index] = Goal(
          id: id,
          title: title,
          desc: desc,
          progress: progress,
          dueDate: dueDate,
          createdDate: createdDate,
          completed: completed,
        );
        notifyListeners();
      }
    } catch (error) {
      print('Error updating goal: $error');
    }
  }

  Future<void> deleteGoal(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentUserEmail = prefs.getString('email') ?? '';
    currentUserEmail =
        DatabaseUtils.convertToHyphenSeparatedEmail(currentUserEmail);
    final DatabaseReference goalsRef = FirebaseDatabase.instance
        .reference()
        .child('patient_data')
        .child(currentUserEmail)
        .child('goals')
        .child(id);
    try {
      await goalsRef.remove();
      _goals.removeWhere((goal) => goal.id == id);
      notifyListeners();
    } catch (error) {
      print('Error deleting goal: $error');
    }
  }
}
