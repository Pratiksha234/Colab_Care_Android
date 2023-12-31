import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:colab_care/controllers/Themes/themes.dart';

class ThemeSelectionScreen extends StatelessWidget {
  ThemeSelectionScreen({Key? key});
  final List<Map<String, dynamic>> themesData = [
    {
      'name': 'Default',
      'imageAsset': 'assets/default.jpg', // Replace with your image asset path
    },
    {
      'name': 'Oceanic Harmony',
      'imageAsset': 'assets/oceanic.jpg', // Replace with your image asset path
    },
    {
      'name': 'Burgundy Twilight',
      'imageAsset': 'assets/burgundy.jpg', // Replace with your image asset path
    },
    {
      'name': 'Soothing Foliage',
      'imageAsset': 'assets/green.jpg', // Replace with your image asset path
    },
    {
      'name': 'Violet Dawn',
      'imageAsset': 'assets/purple.jpg', // Replace with your image asset path
    },
    {
      'name': 'Retro',
      'imageAsset': 'assets/retro.jpg', // Replace with your image asset path
    },
    {
      'name': 'Soft Sands',
      'imageAsset':
          'assets/softsands.jpg', // Replace with your image asset path
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Select Theme',
          style: theme.navbarFont,
        ),
      ),
      body: ListView.builder(
        itemCount: themesData.length, // Total number of themes
        itemBuilder: (context, index) {
          final themeData = themesData[index];
          final themeName = themeData['name'];
          final imageAsset = themeData['imageAsset'];

          final theme = getThemeByIndex(index);

          return GestureDetector(
            onTap: () {
              final themeNotifier =
                  Provider.of<ThemeNotifier>(context, listen: false);
              themeNotifier.currentTheme = theme;
              Navigator.pop(context);
            },
            child: Container(
              height: 120.0,
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: AssetImage(imageAsset),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                themeName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  ThemeProtocol getThemeByIndex(int index) {
    switch (index) {
      case 0:
        return DefaultTheme();
      case 1:
        return OceanicHarmonyTheme();
      case 2:
        return BurgundyTwilightTheme();
      case 3:
        return SoothingFoliageTheme();
      case 4:
        return VioletDawnTheme();
      case 5:
        return RetroTheme();
      case 6:
        return SoftSandsTheme();
      default:
        return DefaultTheme();
    }
  }
}
