import 'package:colab_care/exports.dart';

class CustomMainAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;

  const CustomMainAppbar({super.key, required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(appBarTitle, style: theme.navbarFont),
      ),
      backgroundColor: theme.backgroundGradientStop,
      centerTitle: false,
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
