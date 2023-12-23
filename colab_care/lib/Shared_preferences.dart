import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static Future<void> saveUserDataToSharedPreferences(
      String newEmail, String firstName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('new_email', newEmail);
      prefs.setString('first_name', firstName);
    } catch (e) {
      print("Error saving user data to SharedPreferences: $e");
    }
  }

  static Future<Map<String, String>> getUserDataFromSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String newEmail = prefs.getString('new_email') ?? '';
      String firstName = prefs.getString('first_name') ?? '';

      return {'new_email': newEmail, 'first_name': firstName};
    } catch (e) {
      print("Error getting user data from SharedPreferences: $e");
      return {'new_email': '', 'first_name': ''};
    }
  }
}
