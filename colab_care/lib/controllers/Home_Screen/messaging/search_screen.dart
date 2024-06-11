import 'package:colab_care/controllers/Home_Screen/messaging/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:colab_care/database_access.dart'; // Update this with the actual path
import 'package:intl/intl.dart'; // Make sure to add 'intl' package in your pubspec.yaml
import 'package:timezone/timezone.dart' as tz;

class SearchProviderScreen extends StatefulWidget {
  const SearchProviderScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SearchProviderScreenState();
  }
}

class _SearchProviderScreenState extends State<SearchProviderScreen> {
  List<SearchResult> results = [];
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;
    tz.Location location = tz.getLocation("America/New_York");

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.backgroundColor,
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10), // Add padding around the TextField
                decoration: BoxDecoration(
                  color: theme.backgroundColor, // Set the background color
                  borderRadius: BorderRadius.circular(
                      20), // Optional: if you want rounded corners
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for Provider',
                    fillColor: theme.backgroundGradientStart,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                    ), // Adjust icon color based on theme
                  ),
                  onChanged: (value) => searchUsers(query: value.trim()),
                ),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  Navigator.of(context).pop();
                }),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: results.isNotEmpty
                ? ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(results[index].name, style: theme.navbarFont),
                      subtitle:
                          Text(results[index].email, style: theme.captionFont),
                      onTap: () async {
                        // Assuming currentUserEmail is available in your app scope
                        String currentUserEmail =
                            FirebaseAuth.instance.currentUser!.email!;
                        currentUserEmail =
                            DatabaseUtils.convertToHyphenSeparatedEmail(
                                currentUserEmail);
                        String conversationId = generateConversationId(
                            currentUserEmail, results[index].email, location);

                        // Navigate to the chat screen
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            recipientName: results[index].name,
                            conversationId: conversationId,
                            recipientEmail: results[index].email,
                            senderEmail: currentUserEmail,
                          ),
                        ));

                        // Optionally, initialize conversation thread in Firebase Database
                        await initializeConversationInFirebase(conversationId,
                            currentUserEmail, results[index].email);
                      },
                    ),
                  )
                : Center(
                    child: Text('No results found', style: theme.captionFont)),
          ),
        ],
      ),
    );
  }

  void searchUsers({required String query}) {
    if (query.isEmpty) {
      setState(() => results.clear());
      return;
    }

    DatabaseUtils.getAllUsers(query).then((userResults) {
      setState(() => results = userResults);
    }).catchError((error) {
      print('Error fetching users: $error');
      // Optionally, implement error handling UI/logic
    });
  }

  String generateConversationId(
      String email1, String email2, tz.Location location) {
    // Convert emails to a Firebase-friendly format
    email1 = DatabaseUtils.convertToHyphenSeparatedEmail(email1);
    email2 = DatabaseUtils.convertToHyphenSeparatedEmail(email2);
    tz.TZDateTime now = tz.TZDateTime.now(location);

    List<String> emails = [email1, email2];
    emails.sort(); // Ensure consistency in ID generation
    String timeZoneAbbreviation =
        now.timeZoneName; // Get time zone abbreviation
    print(timeZoneAbbreviation);
    // Format the current date and time
    String formattedDate = DateFormat("MMM d, yyyy 'at' h:mm:ss a").format(now);
    print("conversation_${emails.join('_')}_${formattedDate}");
    return "conversation_${emails.join('_')}_${formattedDate}";
  }

  Future<void> initializeConversationInFirebase(
      String conversationId, String senderEmail, String recipientEmail) async {
    final dbRef = FirebaseDatabase.instance.ref();
    final conversationRef = dbRef.child('conversation_threads/$conversationId');

    // Initialize a new conversation with empty messages
    await conversationRef.set({
      "messages": {},
      // Add additional initialization data as needed
    });
  }
}
