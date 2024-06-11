import 'package:colab_care/exports.dart';

class GoalsDatabaseManager {
  Future<DatabaseReference> getGoalsRef() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentUserEmail = prefs.getString('email') ?? '';
    currentUserEmail =
        DatabaseUtils.convertToHyphenSeparatedEmail(currentUserEmail);
    return FirebaseDatabase.instance
        .ref()
        .child('patient_data')
        .child(currentUserEmail)
        .child('goals');
  }

  Future<DatabaseReference> getGoalRef(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentUserEmail = prefs.getString('email') ?? '';
    currentUserEmail =
        DatabaseUtils.convertToHyphenSeparatedEmail(currentUserEmail);
    return FirebaseDatabase.instance
        .ref()
        .child('patient_data')
        .child(currentUserEmail)
        .child('goals')
        .child(id);
  }
}
