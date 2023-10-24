import 'package:shared_preferences/shared_preferences.dart';

void setImmersiveSticky(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isImmersiveSticky', value);
}
