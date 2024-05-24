// import 'package:permission_handler/permission_handler.dart';

// class PermissionStatusService {
//   // Function to check and request notification permission
//   static Future<bool> checkAndRequestNotificationPermission() async {
//     // Check the current status of notification permission
//     PermissionStatus status = await Permission.notification.status;

//     // If permission is not granted, request permission
//     if (!status.isGranted) {
//       PermissionStatus permissionStatus =
//           await Permission.notification.request();
//       return permissionStatus.isGranted;
//     }

//     // If permission is already granted, return true
//     return true;
//   }
// }
