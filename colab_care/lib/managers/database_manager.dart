import 'package:firebase_database/firebase_database.dart';

class DatabaseManager {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();

  Future<String?> fetchDailyQuote(String dayOfMonth) async {
    final snapshot =
        await _ref.child('quotes/$dayOfMonth').get();
    if (snapshot.exists) {
      print(snapshot.value);
      return snapshot.value as String;
    } else {
      return null;
    }
  }
}