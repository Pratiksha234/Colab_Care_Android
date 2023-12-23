import 'package:firebase_database/firebase_database.dart';

class DatabaseUtils {
  static Future<String?> getFirstNameFromDatabase(String uid) async {
    try {
      DatabaseReference dbRef =
          // ignore: deprecated_member_use
          FirebaseDatabase.instance.reference().child('user-data');

      // Use once() to retrieve data once
      DatabaseEvent dataSnapshot = await dbRef.child(uid).once();

      // Check if the snapshot exists and contains data
      // ignore: unnecessary_null_comparison
      if (dataSnapshot.snapshot != null) {
        String firstName =
            dataSnapshot.snapshot.child('first_name').value.toString();
        return firstName;
      } else {
        // Handle the case where data is not available
        return null;
      }
    } catch (e) {
      // Handle errors
      return null;
    }
  }

  String convertToHyphenSeparatedEmail(String email) {
    // Replace special characters with hyphen
    String sanitizedEmail = email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '-');

    // Convert to lowercase
    sanitizedEmail = sanitizedEmail.toLowerCase();

    return sanitizedEmail;
  }

//   void saveDailyCheckInForm(Map<int, String> answers) async {
//     final currentEmail = await SharedPreferences.getInstance().then(
//       (prefs) => prefs.getString('email'),
//     );

//     if (currentEmail == null) {
//       return;
//     }

//     final currentUserEmail = DatabaseManager.safeEmail(currentEmail);

//     final dateFormatter = DateFormat('yyyyMMdd');
//     final currentDate = dateFormatter.format(DateTime.now());

//     final dailyCheckInRef = FirebaseDatabase.instance.reference().child(
//           'patient_data/$currentUserEmail/dailycheckin/$currentDate',
//         );

//     final convertedAnswers = <String, String>{};
//     answers.forEach((questionNumber, answer) {
//       final key = questionNumber.toString();
//       convertedAnswers[key] = answer;
//     });

//     final completedDateString = DateFormat.custom(
//             dateStyle: DateStyle.medium, timeStyle: TimeStyle.none)
//         .format(DateTime.now());
//     convertedAnswers['date'] = completedDateString;

//     await dailyCheckInRef.set(convertedAnswers);
//   }
}
