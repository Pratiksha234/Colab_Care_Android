import 'package:colab_care/managers/database_manager.dart';

class HomeController {
  final DatabaseManager _databaseManager = DatabaseManager();

  Future<String> fetchDailyQuote() async {
    String dayOfMonth = DateTime.now().day.toString();
    String? quote = await _databaseManager.fetchDailyQuote(dayOfMonth);
    return quote ??
        '“You may not control all the events that happen to you, but you can decide not to be reduced by them.” — Maya Angelou';
  }
}
