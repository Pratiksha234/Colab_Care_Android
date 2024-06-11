import 'package:colab_care/exports.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;

  const CustomAppbar({super.key, required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white, //change your color here
      ),
      title: Text(appBarTitle),
      centerTitle: false,
      backgroundColor: theme.tabBarBackgroundColor,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 28,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
