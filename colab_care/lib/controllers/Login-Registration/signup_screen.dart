import 'package:flutter/foundation.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../views/reusable_widgets.dart';
import 'package:colab_care/exports.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _reenterTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _authCodeTextController = TextEditingController();
  late EncryptionService _encryptionService;

  String? selectedRole;
  String safeEmail = '';
  File? imageFile;
  bool passwordVisible = false;
  bool repasswordVisible = false;

  Future<void> _signUpAndNavigateToHomeScreen() async {
    try {
      final isValidAuth = await checkAuth(); // Check authentication
      if (!isValidAuth) {
        throw Exception("Invalid authentication");
      }
      final value = await _signUpWithEmailAndPassword();
      if (kDebugMode) {
        print("Created New Account");
      }
      final uid = value.user!.uid;
      safeEmail = DatabaseUtils.convertToHyphenSeparatedEmail(
          _emailTextController.text);
      UserData newUser = UserData(
        uid: uid,
        first_name: _firstNameTextController.text,
        last_name: _lastNameTextController.text,
        email: safeEmail,
        user_role: 'Patient',
        token: 'android',
      );
      Map<String, dynamic> newUserMap = newUser.toJson();

      await _saveUserDataToDatabase(uid, newUserMap);
      await _saveUserDataToAllUsers(newUser, newUserMap);
      String new_email =
          DatabaseUtils.convertToHyphenSeparatedEmail(newUser.email);
      await UserData.saveUserDataToSharedPreferences(newUser);
      await _uploadImage(
          new_email, newUser.email); // Upload the image after saving user data

      if (kDebugMode) {
        print("Navigating to HomeScreen");
      }
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TabBarScreen()),
      );
    } catch (error) {
      if (kDebugMode) {
        print("Error ${error.toString()}");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _encryptionService = EncryptionService
        .shared; // Initialize _encryptionService in the initState method
  }

  String? decryptMessage(String encryptedMessage) {
    try {
      return _encryptionService.decrypt(encryptedMessage);
    } catch (e) {
      return "Decryption error: $e";
    }
  }

  Future<bool> checkAuth() async {
    try {
      // Decrypt the authentication code
      String decryptedAuth =
          _encryptionService.decrypt(_authCodeTextController.text);
      print('Decrypted Auth: $decryptedAuth');

      // Query the Firebase Realtime Database
      final snapshot = await FirebaseDatabase.instance
          .ref()
          .child('auth')
          .child('patient')
          .orderByKey() // Order by key
          .equalTo(decryptedAuth)
          .get(); // Use get() instead of once()

      // Log snapshot details for debugging
      print('Snapshot Key: ${snapshot.key}');
      print('Snapshot Value: ${snapshot.value}');
      print('Snapshot Exists: ${snapshot.exists}');

      // Check if the authentication code exists in the database
      if (snapshot.exists && snapshot.value != null) {
        return true; // Authentication successful
      } else {
        print('Authentication code not found');
        return false; // Authentication failed
      }
    } catch (error) {
      // Handle decryption or database query errors
      print('Error Exception: $error');
      return false; // Authentication failed due to error
    }
  }

  Future<void> _uploadImage(String uid, String emaild) async {
    String email = DatabaseUtils.convertToHyphenSeparatedEmail(emaild);
    email = '${email}_profile_picture';
    if (imageFile != null) {
      try {
        final storageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('images')
            .child('$email.png');

        await storageRef.putFile(imageFile!);

        final downloadUrl = await storageRef.getDownloadURL();

        // Save the download URL to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImageUrl', downloadUrl);

        // You can save this `downloadUrl` to your user's profile in the database if needed.
      } catch (error) {
        print('Error uploading image: $error');
      }
    } else {
      imageFile = Image.asset('assets/icon/personal_icon.png') as File?;
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child('$email.png');

      await storageRef.putFile(imageFile!);

      final downloadUrl = await storageRef.getDownloadURL();

      // Save the download URL to SharedPreferences
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString('profileImageUrl', downloadUrl);
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

  Future<void> _saveUserDataToAllUsers(
      UserData user, Map<String, dynamic> userData) async {
    final databaseRef = FirebaseDatabase.instance.ref();
    String newEmail = DatabaseUtils.convertToHyphenSeparatedEmail(user.email);

    // Concatenate last_name to first_name and store as name
    String fullName = '${userData['first_name']} ${userData['last_name']}';

    Map<String, dynamic> userSubset = {
      'email': user.email,
      'name': fullName,
      'token': userData['token'],
      'user_role': userData['user_role'],
    };

    await databaseRef.child('all-users').child(newEmail).set(userSubset);
  }

  final List<String> roleOptions = ["Patient", "Provider"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
            color: Colors.black), // Set the icon color to black
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(
              color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(96, 210, 206, 153),
              Colors.white38,
              Colors.white38,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
            child: Column(
              children: <Widget>[
                buildProfileImage(),
                const SizedBox(height: 20.0),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter First Name",
                  Icons.person_outline,
                  _firstNameTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Last Name",
                  Icons.person_outline,
                  _lastNameTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Email Id",
                  Icons.email_outlined,
                  _emailTextController,
                ),
                const SizedBox(height: 20),
                reusablePasswordField(
                  "Enter Password",
                  Icons.lock_outlined,
                  !passwordVisible,
                  _passwordTextController,
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                reusablePasswordField(
                  "Re-enter Password",
                  Icons.lock_outlined,
                  !repasswordVisible,
                  _reenterTextController,
                  suffixIcon: IconButton(
                    icon: Icon(
                      repasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        repasswordVisible = !repasswordVisible;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Auth Code",
                  Icons.security,
                  _authCodeTextController,
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
                'assets/icon/personal_icon.png',
                height: 150.0,
                width: 150.0,
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Image.file(
                  imageFile!,
                  height: 150.0,
                  width: 150.0,
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
}
