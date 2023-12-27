import 'package:colab_care/controllers/Home_Screen/home_screen.dart';
import 'package:colab_care/controllers/Home_Screen/tab_bar.dart';
import 'package:colab_care/controllers/Login-Registration/signin_screen.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:colab_care/controllers/Themes/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:colab_care/controllers/Home_Screen/reminder_provider.dart';
import 'package:realm/realm.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final settingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
  final settingsIOS = IOSInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {},
  );
  final initializationSettings =
      InitializationSettings(android: settingsAndroid, iOS: settingsIOS);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? payload) async {},
  );


  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RemindersProvider()),
        ChangeNotifierProvider.value(
          value:
              ThemeNotifier(DefaultTheme()), // Provide the ThemeNotifier here
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = themeNotifier.currentTheme;

    return MaterialApp(
      title: 'Colab Care',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primaryColor: theme.backgroundGradientStart,
        backgroundColor: theme.backgroundColor,
      ),
      routes: {
        '/home': (context) => const HomePage(),
      },
      home: const SafeArea(
        top: false,
        bottom: false,
        child: SignInScreen(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colab Care'),
      ),
      body: const SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Hello, Flutter!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
