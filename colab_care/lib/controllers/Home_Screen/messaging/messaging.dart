import 'dart:async';
import 'package:colab_care/exports.dart';

class ChatSummary {
  final String id;
  final String recipientEmail;
  final String recipientName;
  final String latestMessage;
  final String latestMessagedate;
  final bool isRead;

  ChatSummary({
    required this.id,
    required this.recipientEmail,
    required this.recipientName,
    required this.latestMessage,
    required this.latestMessagedate,
    required this.isRead,
  });
}

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({Key? key}) : super(key: key);

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  List<SearchResult> results = [];
  final TextEditingController searchController = TextEditingController();
  String profilePictureURL = '';
  late StreamSubscription _chatSubscription;
  bool _permissionRequested = false;

  @override
  void initState() {
    super.initState();
    // Start listening for chat changes
    _startChatListener();
    _checkAndRequestNotificationPermission(context);
  }

  @override
  void dispose() {
    // Dispose the listener when the screen is disposed
    _chatSubscription.cancel();
    super.dispose();
  }

  Future<void> _checkAndRequestNotificationPermission(
      BuildContext context) async {
    // Check if permission has already been requested
    if (_permissionRequested) return;

    // Set permission requested flag to true to prevent concurrent requests
    _permissionRequested = true;

    // Check notification permission status
    PermissionStatus status = await Permission.notification.status;

    if (!status.isGranted) {
      // If permission is not granted, request it
      PermissionStatus permissionStatus =
          await Permission.notification.request();
      if (!permissionStatus.isGranted) {
        // Permission not granted, show a dialog or message to the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Notification Permission Required'),
              content: const Text(
                  'Please grant permission to receive notifications.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

    // Reset permission requested flag after request is completed
    _permissionRequested = false;
  }

  void _startChatListener() {
    _chatSubscription = DatabaseUtils.fetchActiveChats().listen((chats) {
      // Update the UI when chat data changes
      setState(() {});
    });
  }

  Future<String> getProfileImageUrl(String safeEmail) async {
    String imageFileName = "${safeEmail}_profile_picture.png";

    try {
      final ref = FirebaseStorage.instance.ref('images/$imageFileName');
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error loading profile picture: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      backgroundColor: theme.backgroundGradientStart,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Messaging', style: theme.navbarFont),
        ),
        centerTitle: false,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        backgroundColor: theme.backgroundGradientStart,
        actions: <Widget>[
          IconButton(
            icon: CircleAvatar(
              backgroundColor: theme.buttonTintColor,
              child:
                  const Icon(Icons.person_add_alt_1_sharp, color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SearchProviderScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ChatSummary>>(
        stream: DatabaseUtils.fetchActiveChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("Failed to load chats: ${snapshot.error}");
            return const Center(child: Text('Error loading chats'));
          }

          if (snapshot.data == null) {
            return const Center(child: Text('No chats found'));
          }

          final chats = snapshot.data!;
          if (chats.isEmpty) {
            return const Center(child: Text('No chats found'));
          }
          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: theme.buttonTintColor),
            itemBuilder: (context, index) {
              final chat = snapshot.data![index];
              return ListTile(
                minVerticalPadding: 40,
                leading: FutureBuilder<String>(
                  future: getProfileImageUrl(chat.recipientEmail),
                  builder: (context, snapshot) {
                    return Container(
                      width: 90.0,
                      height: 90.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit
                              .cover, // This ensures the image covers the full container, can be changed to BoxFit.contain, BoxFit.fill, etc.
                          image: snapshot.hasData && snapshot.data!.isNotEmpty
                              ? NetworkImage(snapshot.data!)
                              : const AssetImage(
                                      'assets/icon/personal_icon.png')
                                  as ImageProvider,
                        ),
                      ),
                    );
                  },
                ),
                title: Text(chat.recipientName, style: theme.headerFont),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        return Text((chat.latestMessage),
                            style: theme.textFont);
                      },
                    ),
                    Builder(
                      builder: (context) {
                        return Text(
                          chat.latestMessagedate,
                          style: theme.captionFont
                              .copyWith(fontSize: 12, color: Colors.grey[600]),
                        );
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        conversationId: chat.id,
                        recipientEmail: chat.recipientEmail,
                        senderEmail: FirebaseAuth.instance.currentUser!.email!,
                        recipientName: chat.recipientName,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
