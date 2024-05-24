import 'package:colab_care/exports.dart';

import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  AwesomeNotifications().initialize(
    'resource://drawable/act',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic notifications',
        defaultColor: Colors.teal,
        ledColor: Colors.teal,
      ),
    ],
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();

  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GoalsProvider()),
        ChangeNotifierProvider(create: (_) => RemindersProvider()),
        ChangeNotifierProvider.value(
          value: ThemeNotifier(DefaultTheme()),
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
    return MaterialApp(
      title: 'Colab Care',
      theme: ThemeData(
        primaryColor: Colors.blue,
        backgroundColor: Colors.white,
      ),
      home: StreamBuilder<User?>(
        // Listen to the auth state changes
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If the snapshot has user data and is not waiting for connection, user is logged in
          if (snapshot.connectionState == ConnectionState.active) {
            // If the user is not null, they're logged in, navigate to the HomePage
            if (snapshot.data != null) {
              return const SafeArea(
                top: false,
                bottom: false,
                child:
                    HomePage(), // Assuming HomePage is your main logged-in UI
              );
            } else {
              // If the user is null, they're not logged in, navigate to the SignInScreen
              return const SafeArea(
                top: false,
                bottom: false,
                child: SignInScreen(),
              );
            }
          } else {
            // While checking the auth state, show the SplashScreen
            return SplashScreen(); // Your splash screen widget
          }
        },
      ),
    );
  }

  Future<bool> checkLoggedInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      // Check Firebase Authentication status
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return true;
      } else {
        // User not authenticated with Firebase, logout
        await prefs.setBool('isLoggedIn', false);
        return false;
      }
    }
    return isLoggedIn;
  }
}
