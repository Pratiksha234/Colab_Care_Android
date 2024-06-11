import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String userRole;
  final String token;

  UserData({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.token,
    required this.userRole,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'token': token,
      'user_role': userRole,
    };
  }

  static Future<void> saveUserDataToSharedPreferences(UserData user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      prefs.setString('email', user.email);
      prefs.setString('first_name', user.firstName);
      prefs.setString('last_name', user.lastName);
      prefs.setString('token', user.token);
      prefs.setString('uid', user.uid);
      prefs.setString('user_role', user.userRole);
    } catch (e) {
      // Handle other exceptions that might occur during the process
    }
  }
}
