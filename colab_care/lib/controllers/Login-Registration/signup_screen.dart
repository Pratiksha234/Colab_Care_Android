import 'dart:convert';

import 'package:colab_care/controllers/Home_Screen/home_screen.dart';
import 'package:colab_care/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../../views/reusable_widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _reenterTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _authCodeTextController = TextEditingController();
  String? selectedRole;

  File? imageFile;
  bool passwordVisible = false;

  Future<void> _signUpAndNavigateToHomeScreen() async {
    try {
      final value = await _signUpWithEmailAndPassword();
      if (kDebugMode) {
        print("Created New Account");
      }
      final uid = value.user!.uid;

      UserData newUser = UserData(
        uid: uid,
        first_name: _firstNameTextController.text,
        last_name: _lastNameTextController.text,
        email: _emailTextController.text,
        user_role: 'Patient',
        token: 'android',
      );
      Map<String, dynamic> newUserMap = newUser.toJson();

      await _saveUserDataToDatabase(uid, newUserMap);
      await saveUserDataToSharedPreferences(newUser);

      await _uploadImage(uid); // Upload the image after saving user data

      if (kDebugMode) {
        print("Navigating to HomeScreen");
      }
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (error) {
      if (kDebugMode) {
        print("Error ${error.toString()}");
      }
    }
  }

  Future<void> _uploadImage(String uid) async {
    if (imageFile != null) {
      try {
        final storageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('images')
            .child('$uid.jpg');

        await storageRef.putFile(imageFile!);

        final downloadUrl = await storageRef.getDownloadURL();
        // You can save this `downloadUrl` to your user's profile in the database if needed.
      } catch (error) {
        print('Error uploading image: $error');
      }
    }
  }

  Future<UserCredential> _signUpWithEmailAndPassword() async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailTextController.text,
      password: _passwordTextController.text,
    );
  }

  Future<void> _saveUserDataToDatabase(
      String uid, Map<String, dynamic> userData) async {
    final databaseRef = FirebaseDatabase.instance.ref();
    await databaseRef.child('user-data').child(uid).set(userData);
  }

  final List<String> roleOptions = ["Patient", "Provider"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
            color: Colors.black), // Set the icon color to black
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(96, 210, 206, 153),
              Color.fromARGB(96, 210, 206, 153),
              Color.fromARGB(96, 210, 206, 153),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                buildProfileImage(),
                const SizedBox(height: 20.0),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter First Name",
                  Icons.person_outline,
                  false,
                  _firstNameTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Last Name",
                  Icons.person_outline,
                  false,
                  _lastNameTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Email Id",
                  Icons.email_outlined,
                  false,
                  _emailTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outlined,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Re-enter Password",
                  Icons.lock_outlined,
                  true,
                  _reenterTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Auth Code",
                  Icons.security,
                  true,
                  _authCodeTextController,
                ),
                const SizedBox(height: 20),
                reusableRoleDropdown(
                  "Select Role",
                  Icons.person_outline,
                  roleOptions,
                  selectedRole,
                  (String? newValue) {
                    setState(() {
                      selectedRole = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),
                buildFirebaseUIButton(
                  context,
                  "Sign Up",
                  _signUpAndNavigateToHomeScreen,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileImage() {
    return Stack(
      alignment:
          Alignment.bottomRight, // Align the icon to the bottom-right corner
      children: [
        imageFile == null
            ? Image.asset(
                'assets/personal_icon.png',
                height: 100.0,
                width: 100.0,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Image.file(
                  imageFile!,
                  height: 200.0,
                  width: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
        InkWell(
          onTap: _handleImageSelection,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue, // Customize the button color
            ),
            child: const Icon(
              Icons.camera_alt, // You can use any icon here
              color: Colors.white, // Customize the icon color
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImageSelectionButton() {
    return ElevatedButton(
      onPressed: _handleImageSelection,
      child: const Text('Select Image'),
    );
  }

  Widget buildFirebaseUIButton(
      BuildContext context, String label, Function() onPressed) {
    return firebaseUIButton(context, label, onPressed);
  }

  void _handleImageSelection() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
    ].request();

    if (statuses[Permission.storage]!.isPermanentlyDenied ||
        statuses[Permission.camera]!.isPermanentlyDenied) {
      openAppSettings();
      return;
    }

    if (kDebugMode) {
      print("done");
    }
    if (kDebugMode) {
      print(statuses[Permission.storage]);
    }

    if (statuses[Permission.storage]!.isGranted &&
        statuses[Permission.camera]!.isGranted) {
      // ignore: use_build_context_synchronously
      showImagePicker(context);
    } else {
      if (kDebugMode) {
        print('no permission provided');
      }
    }
  }

  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: const Column(
                      children: [
                        Icon(
                          Icons.image,
                          size: 60.0,
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          "Gallery",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )
                      ],
                    ),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 60.0,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Camera",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _imgFromGallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      if (value != null) {
        setState(() {
          imageFile = File(value.path);
        });
      }
    });
  }

  void _imgFromCamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((value) {
      if (value != null) {
        setState(() {
          imageFile = File(value.path);
        });
      }
    });
  }

  Future<void> saveUserDataToSharedPreferences(UserData user) async {
    final prefs = await SharedPreferences.getInstance();
    final userMap = user.toJson();
    final userString = jsonEncode(userMap);
    prefs.setString('user_data', userString);
  }
}
