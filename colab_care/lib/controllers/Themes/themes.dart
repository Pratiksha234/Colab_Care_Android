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
  final String backgroundImage;

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
          backgroundGradientStart: const Color(0xFFFAF1E4),
          backgroundGradientStop: const Color(0xFFFAF1E4),
          borderColor: Colors.black,
          buttonTintColor: const Color.fromARGB(255, 238, 238, 238),
          tabBarBackgroundColor: Colors.black,
          tabBarSelectedItemColor: Colors.white,
          tabBarUnselectedItemColor: Colors.grey,
          headerColor: Colors.black,
          textColor: Colors.black,
          navbarFont: const TextStyle(
              fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black),
          textFont: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          captionFont:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
          headerFont: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
          backgroundColor: Colors.white,
          backgroundImage: "assets/default.jpg",
        );
}

class OceanicHarmonyTheme extends ThemeProtocol {
  OceanicHarmonyTheme()
      : super(
          backgroundGradientStart: const Color.fromRGBO(203, 228, 222, 1),
          backgroundGradientStop: const Color.fromRGBO(203, 228, 222, 1),
          borderColor: const Color.fromRGBO(71, 223, 221, 1),
          buttonTintColor: const Color.fromARGB(255, 95, 168, 192),
          tabBarBackgroundColor: const Color.fromARGB(255, 15, 90, 115),
          tabBarSelectedItemColor: Colors.white,
          tabBarUnselectedItemColor: Colors.grey.shade400,
          headerColor: const Color.fromRGBO(14, 131, 136, 1),
          textColor: const Color.fromRGBO(14, 131, 136, 1),
          navbarFont: const TextStyle(
            fontFamily: "Avenir-Heavy",
            fontSize: 34,
          ),
          textFont: const TextStyle(
            fontFamily: "Avenir-Light",
            fontSize: 16,
            color: Color.fromRGBO(14, 131, 136, 1),
          ),
          captionFont: const TextStyle(
            fontFamily: "Avenir-Light",
            fontSize: 14,
          ),
          headerFont: const TextStyle(
            fontFamily: "Avenir-Medium",
            fontSize: 18,
            color: Color.fromRGBO(14, 131, 136, 1),
          ),
          backgroundColor: const Color.fromARGB(255, 161, 192, 189),
          backgroundImage: "assets/oceanic.jpg",
        );
}

class BurgundyTwilightTheme extends ThemeProtocol {
  BurgundyTwilightTheme()
      : super(
          backgroundGradientStart: const Color(0xFFE7CBCB),
          backgroundGradientStop: const Color(0xFFE7CBCB),
          borderColor: const Color.fromRGBO(71, 223, 221, 1),
          buttonTintColor: const Color.fromARGB(255, 123, 153, 201),
          tabBarBackgroundColor: const Color.fromRGBO(07, 42, 48, 1.00),
          tabBarSelectedItemColor: Colors.white,
          tabBarUnselectedItemColor: const Color.fromRGBO(195, 182, 132, 1),
          headerColor: const Color.fromRGBO(198, 212, 215, 1),
          textColor: const Color.fromRGBO(07, 42, 48, 1.00),
          navbarFont: const TextStyle(
            fontFamily: "Avenir-Heavy",
            fontSize: 34,
          ),
          textFont: const TextStyle(
            fontFamily: "Avenir-Light",
            fontSize: 16,
          ),
          captionFont: const TextStyle(
            fontFamily: "Avenir-Light",
            fontSize: 14,
          ),
          headerFont: const TextStyle(
            fontFamily: "Avenir-Medium",
            fontSize: 18,
          ),
          backgroundColor: const Color.fromRGBO(76, 87, 86, 1.00),
          backgroundImage: "assets/burgundy.jpg",
        );
}
