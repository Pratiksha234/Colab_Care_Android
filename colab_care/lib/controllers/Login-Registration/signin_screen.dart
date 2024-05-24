import 'dart:async';
import 'package:colab_care/controllers/Home_Screen/home/tab_bar.dart';
import 'package:colab_care/controllers/Login-Registration/reset_password.dart';
import 'package:colab_care/controllers/Login-Registration/signup_screen.dart';
import 'package:colab_care/database_access.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:colab_care/views/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  int currentIndex = 0;
  List<String> messages = [
    "Hello!",
    "How are you?",
    "Your courage is admired.",
    "Your resilience is inspiring.",
    "You make a difference.",
    "Your dedication is valued.",
    "Keep Going!",
    "Your strength inspires us.",
    "We appreciate you.",
    "Please, use our app."
  ];

  List<Color> pastelColors = [
    const Color.fromARGB(255, 247, 198, 214),
    const Color.fromARGB(255, 192, 243, 194),
    const Color.fromARGB(255, 253, 245, 170),
    const Color.fromARGB(255, 234, 181, 243),
    const Color.fromARGB(255, 176, 219, 255),
    const Color.fromARGB(255, 240, 205, 152),
    Colors.blueGrey[200]!,
    const Color.fromARGB(255, 217, 241, 188),
    const Color.fromARGB(255, 243, 212, 223),
    const Color.fromARGB(255, 212, 240, 213),
  ];

  Color backgroundColor = Colors.pink[200]!;
  Color messageLabelColor = Colors.black;

  Timer? typingTimer;
  String currentMessage = "";

  @override
  void initState() {
    super.initState();
    startTyping();
  }

  @override
  void dispose() {
    typingTimer?.cancel();
    super.dispose();
  }

  void startTyping() {
    if (currentIndex >= messages.length) {
      currentIndex = 0; // Reset the index to restart the animation
    }

    String message = messages[currentIndex];
    int letterIndex = 0;

    typingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        if (letterIndex <= message.length) {
          setState(() {
            currentMessage = message.substring(0, letterIndex);
          });
          letterIndex++;
        } else {
          currentIndex++;
          if (currentIndex >= messages.length) {
            // Restart the animation
            currentIndex = 0;
            message = messages[currentIndex];
            letterIndex = 0;
          } else {
            message = messages[currentIndex];
            letterIndex = 0;
          }
        }
      } else {
        typingTimer?.cancel();
      }
    });
  }

  Color complementaryColor(Color color) {
    final double relativeLuminance =
        (0.2126 * color.red + 0.7152 * color.green + 0.0722 * color.blue) /
            255.0;
    if (relativeLuminance > 0.5) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  List<IconData> iconsList = [
    Icons.waving_hand,
    Icons.emoji_emotions,
    Icons.thumb_up_alt,
    Icons.groups_outlined,
    Icons.camera,
    Icons.gpp_good_outlined,
    Icons.show_chart,
    Icons.book,
    Icons.favorite,
    Icons.sentiment_very_satisfied,
  ];

  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: pastelColors[currentIndex],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  Icon(
                    iconsList[currentIndex],
                    size: 64,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    currentMessage,
                    style: GoogleFonts.openSans(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  reusableTextField("Enter Name or Email", Icons.person_outline,
                      _emailTextController),
                  const SizedBox(
                    height: 20,
                  ),
                  reusablePasswordField(
                    "Enter Password",
                    Icons.lock_outlined,
                    !passwordVisible,
                    _passwordTextController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  forgetPassword(context),
                  firebaseUIButton(context, "Sign In", () async {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      );
                      String? uid = userCredential.user?.uid;
                      print(uid);
                      if (userCredential.user != null) {
                        DatabaseUtils.saveUserDatatoSharedPreference(
                            uid!, _emailTextController.text);
                      }

                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                      // Handle case where first name is null
                    } catch (error) {
                      print("Error $error");
                      // ignore: use_build_context_synchronously
                      showCustomDialog(
                        context,
                        'Incorrect Credentials',
                        "Please enter the details again.",
                        Icons.error_outline,
                        "Ok",
                      );
                    }
                  }),
                  signUpOption(),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ResetPassword())),
      ),
    );
  }
}
