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

// class ThemeManager {
//   static ThemeData getDefaultTheme(ThemeProtocol themeData) {
//     return ThemeData(
//       primaryColor: themeData.backgroundGradientStart,
//     );
//   }
// }

class DefaultTheme extends ThemeProtocol {
  DefaultTheme()
      : super(
          backgroundGradientStart: const Color(0xFFFAF1E4),
          backgroundGradientStop: const Color(0xFFFAF1E4),
          borderColor: Colors.black,
          buttonTintColor: Colors.black,
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
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
          backgroundColor: Colors.white,
          backgroundImage: "assets/theme/default.jpg",
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
            color: Color.fromARGB(255, 15, 90, 115),
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
            fontSize: 20,
            color: Color.fromRGBO(14, 131, 136, 1),
          ),
          backgroundColor: const Color.fromARGB(255, 161, 192, 189),
          backgroundImage: "assets/theme/oceanic.jpg",
        );
}

class BurgundyTwilightTheme extends ThemeProtocol {
  BurgundyTwilightTheme()
      : super(
          backgroundGradientStart: const Color.fromRGBO(231, 204, 204, 1),
          backgroundGradientStop: const Color.fromRGBO(207, 181, 166, 1),
          borderColor: const Color.fromARGB(255, 188, 160, 167),
          buttonTintColor: const Color.fromARGB(255, 153, 97, 123),
          tabBarBackgroundColor: const Color.fromARGB(255, 100, 56, 66),
          tabBarSelectedItemColor: Colors.white,
          tabBarUnselectedItemColor: Colors.grey.shade400,
          headerColor: const Color.fromRGBO(153, 97, 123, 1),
          textColor: const Color.fromRGBO(153, 97, 123, 1),
          navbarFont: const TextStyle(
            fontFamily: "HelveticaNeue-CondensedBold",
            fontSize: 34,
            color: Colors.black,
          ),
          textFont: const TextStyle(
            fontFamily: "HelveticaNeue-Light",
            fontSize: 16,
          ),
          captionFont: const TextStyle(
            fontFamily: "HelveticaNeue-Light",
            fontSize: 14,
          ),
          headerFont: const TextStyle(
            fontFamily: "HelveticaNeue",
            fontSize: 20,
            color: Color.fromARGB(255, 100, 56, 66),
          ),
          backgroundColor: const Color.fromRGBO(231, 204, 204, 1),
          backgroundImage: "assets/theme/burgundy.jpg",
        );
}

class SoothingFoliageTheme extends ThemeProtocol {
  SoothingFoliageTheme()
      : super(
          backgroundGradientStart: const Color.fromRGBO(238, 242, 214, 1),
          backgroundGradientStop: const Color.fromRGBO(173, 204, 177, 1),
          borderColor: const Color.fromRGBO(64, 82, 59, 1),
          buttonTintColor: const Color.fromRGBO(98, 153, 102, 1),
          tabBarBackgroundColor: const Color.fromRGBO(64, 82, 59, 1),
          tabBarSelectedItemColor: const Color.fromRGBO(238, 242, 214, 1),
          tabBarUnselectedItemColor: const Color.fromRGBO(158, 191, 140, 1),
          headerColor: const Color.fromRGBO(64, 82, 59, 1),
          textColor: const Color.fromRGBO(98, 153, 102, 1),
          navbarFont: const TextStyle(
            fontFamily: "AvenirNext-Bold",
            fontSize: 34,
            color: Colors.black,
          ),
          textFont: const TextStyle(
            fontFamily: "AvenirNext-Regular",
            fontSize: 16,
          ),
          captionFont: const TextStyle(
            fontFamily: "AvenirNext-Regular",
            fontSize: 14,
          ),
          headerFont: const TextStyle(
            fontFamily: "AvenirNext-DemiBold",
            fontSize: 20,
            color: Color.fromRGBO(64, 82, 59, 1),
          ),
          backgroundColor: const Color.fromRGBO(238, 242, 214, 1),
          backgroundImage: "assets/theme/green.jpg",
        );
}

class VioletDawnTheme extends ThemeProtocol {
  VioletDawnTheme()
      : super(
          backgroundGradientStart: const Color.fromRGBO(222, 212, 242, 1),
          backgroundGradientStop: const Color.fromRGBO(223, 215, 242, 1),
          borderColor: const Color.fromRGBO(100, 92, 186, 1),
          buttonTintColor: const Color.fromRGBO(162, 132, 219, 1),
          tabBarBackgroundColor: const Color.fromRGBO(100, 92, 186, 1),
          tabBarSelectedItemColor: Colors.white,
          tabBarUnselectedItemColor: const Color.fromRGBO(192, 171, 228, 1),
          headerColor: const Color.fromARGB(255, 29, 29, 32),
          textColor: const Color.fromRGBO(100, 92, 186, 1),
          navbarFont: const TextStyle(
            fontFamily: "Verdana-Bold",
            fontSize: 30,
          ),
          textFont: const TextStyle(
            fontFamily: "Verdana",
            fontSize: 14,
          ),
          captionFont: const TextStyle(
            fontFamily: "Verdana",
            fontSize: 12,
          ),
          headerFont: const TextStyle(
            fontFamily: "Verdana-Bold",
            fontSize: 20,
          ),
          backgroundColor: const Color.fromRGBO(207, 194, 238, 1),
          backgroundImage: "assets/theme/purple.jpg",
        );
}

class RetroTheme extends ThemeProtocol {
  RetroTheme()
      : super(
          backgroundGradientStart: const Color.fromRGBO(204, 214, 197, 1),
          backgroundGradientStop: const Color.fromRGBO(204, 214, 197, 1),
          borderColor: const Color.fromRGBO(125, 151, 172, 1),
          buttonTintColor: const Color.fromRGBO(125, 151, 172, 1),
          tabBarBackgroundColor: const Color.fromRGBO(125, 151, 172, 1),
          tabBarSelectedItemColor: Colors.white,
          tabBarUnselectedItemColor: const Color.fromRGBO(238, 199, 176, 1),
          headerColor: const Color.fromRGBO(84, 113, 131, 1),
          textColor: const Color.fromRGBO(84, 113, 131, 1),
          navbarFont: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textFont: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w100,
          ),
          captionFont: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w100,
          ),
          headerFont: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          backgroundColor: const Color.fromRGBO(194, 194, 194, 1),
          backgroundImage: "assets/theme/retro.jpg",
        );
}

class SoftSandsTheme extends ThemeProtocol {
  SoftSandsTheme()
      : super(
          backgroundGradientStart: const Color.fromRGBO(250, 250, 232, 1),
          backgroundGradientStop: const Color.fromRGBO(239, 205, 182, 1),
          borderColor: const Color.fromRGBO(252, 112, 122, 1),
          buttonTintColor: const Color.fromRGBO(252, 112, 122, 1),
          tabBarBackgroundColor: const Color.fromRGBO(252, 112, 122, 1),
          tabBarSelectedItemColor: const Color.fromRGBO(240, 238, 213, 1),
          tabBarUnselectedItemColor: const Color.fromRGBO(250, 250, 232, 1),
          headerColor: const Color.fromRGBO(252, 112, 122, 1),
          textColor: const Color.fromRGBO(252, 112, 122, 1),
          navbarFont: const TextStyle(
            fontFamily: "TrebuchetMS-Bold",
            fontSize: 34,
            color: Colors.black,
          ),
          textFont: const TextStyle(
            fontFamily: "TrebuchetMS",
            fontSize: 16,
          ),
          captionFont: const TextStyle(
            fontFamily: "TrebuchetMS",
            fontSize: 14,
          ),
          headerFont: const TextStyle(
            fontFamily: "TrebuchetMS-Bold",
            fontSize: 20,
          ),
          backgroundColor: const Color.fromRGBO(250, 250, 232, 1),
          backgroundImage: "assets/theme/softsands.jpg",
        );
}
