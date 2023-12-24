import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:colab_care/controllers/Themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Theme'),
      ),
      body: ListView(
        children: List.generate(7, (index) {
          return ListTile(
            title: Text('Theme ${index + 1}'),
            onTap: () {
              final themeNotifier =
                  Provider.of<ThemeNotifier>(context, listen: false);
              themeNotifier.currentTheme = getThemeByIndex(index);
              Navigator.pop(context);
            },
          );
        }),
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
      default:
        return DefaultTheme();
    }
  }
}
