import 'package:colab_care/controllers/Themes/themes.dart';
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeProtocol _currentTheme;

  ThemeNotifier(this._currentTheme);

  ThemeProtocol get currentTheme => _currentTheme;

  set currentTheme(ThemeProtocol theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
