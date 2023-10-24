// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// // import 'package:flutter_photopicker/flutter_photopicker.dart';

// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String userName = '';
//   String userEmail = '';
//   String profilePictureURL = '';

//   List<String> patientProfileData = [
//     "User Guide",
//     "Configure Daily Check-In",
//     "Logout"
//   ];
//   // List<Widget?> patientProfileImages = [
//   //   SvgPicture.asset("assets/information.svg"),
//   //   SvgPicture.asset("assets/notification.svg"),
//   //   SvgPicture.asset("assets/logout.svg")
//   // ];

//   // List<String> providerProfileData = ["Logout"];
//   // List<Widget?> providerProfileImages = [SvgPicture.asset("assets/logout.svg")];

//   List<String> profileData = [];
//   List<Widget?> profileImages = [];

//   @override
//   void initState() {
//     super.initState();
//     checkUserRole();
//     setProfileInfo();
//     setProfileImage();
//   }

//   // void checkUserRole() {
//   //   final isProvider = _auth.currentUser?.providerData.first.providerId ==
//   //       'password'; // Check if the user is a provider
//   //   profileData = isProvider ? providerProfileData : patientProfileData;
//   //   profileImages = isProvider ? providerProfileImages : patientProfileImages;
//   // }

//   void setProfileInfo() {
//     final user = _auth.currentUser;
//     if (user != null) {
//       userName = user.displayName ?? '';
//       userEmail = user.email ?? '';
//     }
//   }

//   void setProfileImage() {
//     final user = _auth.currentUser;
//     if (user != null) {
//       profilePictureURL = user.photoURL ?? '';
//     }
//   }

//   void updatePictureInBackend() {
//     // Implement Firebase Storage image upload here
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             // Add background image here
//             // Use an Image or Container with a background image

//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.blue,
//                     Colors.blue
//                   ], // Adjust colors accordingly
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       // Handle profile picture change
//                       // You can open a photo picker here
//                       presentPhotoActionSheet();
//                     },
//                     child: CircleAvatar(
//                       radius: 75,
//                       backgroundImage: NetworkImage(profilePictureURL),
//                       child: profilePictureURL.isEmpty
//                           ? Icon(Icons.person, size: 75)
//                           : null,
//                     ),
//                   ),
//                   Text(
//                     userName,
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     userEmail,
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),

//             // Add the profile data buttons here using ListView.builder
//             Expanded(
//               child: ListView.builder(
//                 itemCount: profileData.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     leading: profileImages[index],
//                     title: Text(profileData[index]),
//                     onTap: () {
//                       handleProfileDataTapped(index);
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void presentPhotoActionSheet() {
//     // Implement the photo picker here
//     // Use Flutter Photo Picker or other libraries
//   }

//   void handleProfileDataTapped(int index) {
//     if (profileData[index] == 'User Guide') {
//       // Handle User Guide button tap
//       // Navigate to the User Guide screen
//     } else if (profileData[index] == 'Configure Daily Check-In') {
//       // Handle Configure Daily Check-In button tap
//       // Navigate to the Configure Daily Check-In screen
//     } else if (profileData[index] == 'Logout') {
//       // Handle Logout button tap
//       // Implement the logout logic here
//     }
//   }
// }
