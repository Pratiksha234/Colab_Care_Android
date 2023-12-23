import 'package:flutter/material.dart';

class ThemeProtocol {
  final Color backgroundGradientStart;
  final Color backgroundGradientStop;
  final Color borderColor;
  final Color buttonTintColor;
  final Color tabBarBackgroundColor;
  final Color tabBarSelectedItemColor;
  final Color tabBarUnselectedItemColor;
  final Color headerColor;
  final Color textColor;
  final TextStyle navbarFont;
  final TextStyle textFont;
  final TextStyle captionFont;
  final TextStyle headerFont;
  final Color backgroundColor;
  final ImageProvider backgroundImage;

  ThemeProtocol({
    required this.backgroundGradientStart,
    required this.backgroundGradientStop,
    required this.borderColor,
    required this.buttonTintColor,
    required this.tabBarBackgroundColor,
    required this.tabBarSelectedItemColor,
    required this.tabBarUnselectedItemColor,
    required this.headerColor,
    required this.textColor,
    required this.navbarFont,
    required this.textFont,
    required this.captionFont,
    required this.headerFont,
    required this.backgroundColor,
    required this.backgroundImage,
  });
}

class ThemeManager {
  static ThemeData getDefaultTheme(ThemeProtocol themeData) {
    return ThemeData(
      primaryColor: themeData.backgroundGradientStart,
      backgroundColor: themeData.backgroundColor,
    );
  }
}

class DefaultTheme extends ThemeProtocol {
  DefaultTheme()
      : super(
          backgroundGradientStart: Color.fromRGBO(85, 87, 89, 1.00),
          backgroundGradientStop: Color.fromRGBO(69, 74, 77, 1.00),
          borderColor: Colors.black,
          buttonTintColor: Colors.black,
          tabBarBackgroundColor: Colors.black,
          tabBarSelectedItemColor: Colors.white,
          tabBarUnselectedItemColor: Colors.grey,
          headerColor: Colors.black,
          textColor: Colors.black,
          navbarFont: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          textFont: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          captionFont: TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
          headerFont: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          backgroundColor: Colors.white,
          backgroundImage: AssetImage("assets/original.jpg"),
        );
}

class OceanicHarmonyTheme extends ThemeProtocol {
  OceanicHarmonyTheme()
      : super(
          backgroundGradientStart: Color.fromRGBO(76, 87, 86, 1.00),
          backgroundGradientStop: Color.fromRGBO(64, 77, 81, 1.00),
          borderColor: Color.fromRGBO(07, 42, 48, 1.00),
          buttonTintColor: Color.fromRGBO(07, 42, 48, 1.00),
          tabBarBackgroundColor: Color.fromRGBO(07, 42, 48, 1.00),
          tabBarSelectedItemColor: Colors.white,
          tabBarUnselectedItemColor: Color.fromRGBO(93, 90, 78, 1.00),
          headerColor: Color.fromRGBO(07, 42, 48, 1.00),
          textColor: Color.fromRGBO(07, 42, 48, 1.00),
          navbarFont: TextStyle(
            fontFamily: "Avenir-Heavy",
            fontSize: 34,
          ),
          textFont: TextStyle(
            fontFamily: "Avenir-Light",
            fontSize: 16,
          ),
          captionFont: TextStyle(
            fontFamily: "Avenir-Light",
            fontSize: 14,
          ),
          headerFont: TextStyle(
            fontFamily: "Avenir-Medium",
            fontSize: 18,
          ),
          backgroundColor: Color.fromRGBO(76, 87, 86, 1.00),
          backgroundImage: AssetImage("assets/oceanic.jpg"),
        );
}

// Add similar classes for other themes...

// Example of usage:

