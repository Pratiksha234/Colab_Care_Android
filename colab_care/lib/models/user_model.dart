import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  final String uid;
  final String first_name;
  final String last_name;
  final String email;
  final String user_role;
  final String token;

  UserData({
    required this.uid,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.token,
    required this.user_role,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'token': token,
      // 'goals': goals,
      'user_role': user_role,
      // 'daily Check in': dailyCheckin,
      // 'val1': val1,
      // 'val2': val2,
    };
  }

  static Future<void> saveUserDataToSharedPreferences(UserData user) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      prefs.setString('email', user.email);
      prefs.setString('first_name', user.first_name);
      prefs.setString('last_name', user.last_name);
      prefs.setString('token', user.token);
      prefs.setString('uid', user.uid);
      prefs.setString('user_role', user.user_role);
    } catch (e) {
      // Handle other exceptions that might occur during the process
    }
  }
}
