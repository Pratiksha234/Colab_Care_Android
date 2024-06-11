import 'package:intl/intl.dart';
import 'package:colab_care/exports.dart';

// Define a ChatMessage model to handle the data of each chat message
class ChatMessage {
  final String id;
  final String date;
  final bool isRead;
  final String recipientEmail;
  final String senderEmail;
  final String senderName;
  final String type;
  final String content;

  ChatMessage({
    required this.id,
    required this.date,
    required this.isRead,
    required this.recipientEmail,
    required this.senderEmail,
    required this.senderName,
    required this.type,
    required this.content,
  });
  factory ChatMessage.fromMap(Map<dynamic, dynamic> data, String key) {
    return ChatMessage(
      id: key,
      date: data['date'] as String,
      isRead: data['is_read'] as bool,
      recipientEmail: data['recipient_email'] as String,
      senderEmail: data['sender_email'] as String,
      senderName: data['sender_name'] as String,
      type: data['type'] as String,
      content: data['content'] as String,
    );
  }
  // factory ChatMessage.fromDocument(DocumentSnapshot doc) {
  //   return ChatMessage(
  //     id: doc.id,
  //     date: doc['date'] as String,
  //     isRead: doc['is_read'] as bool,
  //     recipientEmail: doc['recipient_email'] as String,
  //     senderEmail: doc['sender_email'] as String,
  //     senderName: doc['sender_name'] as String,
  //     type: doc['type'] as String,
  //   );
  // }
}

class SearchResult {
  final String name;
  final String email;
  final String role;
  SearchResult({required this.name, required this.email, required this.role});
}

class ConversationSummary {
  final String id; // Add this line
  final String recipientName;
  final String latestMessage;
  final String profilePictureUrl;

  ConversationSummary({
    required this.id, // Add this line
    required this.recipientName,
    required this.latestMessage,
    required this.profilePictureUrl,
    required recipientEmail,
  });
}

class DatabaseUtils {
  static final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  static Future<List<SearchResult>> getAllUsers(String query) async {
    final snapshot = await _dbRef.child('all-users').get();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Adjusting the roles to match the database key "user_role"
    String currentUserRole = prefs.getString('user_role') ??
        'Patient'; // Assuming the key stored in prefs is 'user_role'
    String roleToFilterFor =
        currentUserRole == "Patient" ? "Provider" : "Patient";

    if (snapshot.exists && snapshot.value != null) {
      final users = Map<String, dynamic>.from(snapshot.value as Map);
      return users.entries
          .map((entry) {
            final user = entry.value;
            final name = user['name'] as String? ?? 'No Name';
            final email = user['email'] as String? ?? 'No Email';
            final role = user['user_role'] as String? ??
                'No Role'; // Changed to match your database structure
            return SearchResult(name: name, email: email, role: role);
          })
          .where((user) =>
              user.role.toLowerCase() == roleToFilterFor.toLowerCase())
          .where(
              (user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      print('No data available.');
      return [];
    }
  }

  static Future<List<ConversationSummary>> fetchUserConversations() async {
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    final sanitizedEmail =
        DatabaseUtils.convertToHyphenSeparatedEmail(currentUserEmail);
    print(sanitizedEmail);
    final dbRef = FirebaseDatabase.instance.ref();
    final snapshot =
        await dbRef.child('user-chats/$sanitizedEmail/conversations').get();

    if (!snapshot.exists || snapshot.value == null) {
      return [];
    }

    List<ConversationSummary> conversations = [];
    Map<String, dynamic> conversationsData =
        Map<String, dynamic>.from(snapshot.value as Map);
    conversationsData.forEach((key, value) {
      conversations.add(ConversationSummary(
        id: key,
        recipientEmail: value['recipient_email'],
        recipientName: value['recipient_name'],
        latestMessage: value['latest_message'] ?? '',
        profilePictureUrl: '',
      ));
    });

    return conversations;
  }

  static Future<void> sendMessage({
    required String senderEmail,
    required String recipientEmail,
    required String messageText,
    required String recipientName,
    required String conversationId,
  }) async {
    // Formatting sender and recipient emails for use in database paths
    final String formattedSenderEmail =
        convertToHyphenSeparatedEmail(senderEmail);
    final String formattedRecipientEmail =
        convertToHyphenSeparatedEmail(recipientEmail);

    // Generating a unique timestamp for the conversationId
    final String timestamp =
        DateFormat("MMM d, yyyy 'at' h:mm:ss a z").format(DateTime.now());
    final String latest_time =
        DateFormat("MM/dd/yy, h:mm a").format(DateTime.now());
    // Constructing the conversationId
    String id = '$formattedSenderEmail\_$formattedRecipientEmail\_$timestamp';

    // Encrypt the message text
    String encryptedContent = EncryptionService.shared.encrypt(messageText);

    // Constructing the DatabaseReference for the new message
    final DatabaseReference messageRef = FirebaseDatabase.instance.ref(
        'conversation_threads/$conversationId/messages/$id'); // Using push() to generate a unique message ID under the conversationId

    // Setting the message data, including the conversationId within each message
    await messageRef.set({
      'conversation_id': id, // Including the conversationId as an attribute
      'sender_email': formattedSenderEmail,
      'recipient_email': formattedRecipientEmail,
      'content': encryptedContent,
      'date': timestamp, // Using Firebase's server timestamp
      'sender_name': recipientName,
      'type': 'text',
      'is_read': false,
    });

    final DatabaseReference latestMsg = FirebaseDatabase.instance.ref(
        'user-chats/$formattedSenderEmail/conversations/$conversationId/latest_message/');
    await latestMsg.set({
      'content': encryptedContent,
      'date': latest_time, // Using Firebase's server timestamp
      'is_read': false,
    });
  }

  static Stream<List<ChatMessage>> fetchChatMessages(String conversationId) {
    return FirebaseDatabase.instance
        .ref('conversation_threads/$conversationId/messages')
        .orderByChild('date') // Assuming you have a 'date' field for ordering
        .onValue
        .map((event) {
      final messagesList = <ChatMessage>[];
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        data.forEach((key, value) {
          final message = ChatMessage.fromMap(
              value, key); // Make sure to have a fromMap constructor
          messagesList.add(message);
        });
      }
      return messagesList;
    });
  }

  static Stream<List<ChatSummary>> fetchActiveChats() {
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    final sanitizedEmail = convertToHyphenSeparatedEmail(
        currentUserEmail); // Implement this method if needed
    final dbRef = FirebaseDatabase.instance.reference();

    return dbRef
        .child('user-chats/$sanitizedEmail/conversations')
        .onValue
        .map((event) {
      final chatsSnapshot = event.snapshot;
      if (!chatsSnapshot.exists || chatsSnapshot.value == null) {
        return <ChatSummary>[]; // Return an empty list if no chats exist
      }

      final chatData = Map<String, dynamic>.from(
          chatsSnapshot.value! as Map<dynamic, dynamic>);
      final List<ChatSummary> chats = [];

      chatData.forEach((key, value) {
        // Extracting fields from the latest_message map
        final latestMessageMap =
            value['latest_message'] as Map<dynamic, dynamic>? ?? {};
        final recipientName = value['recipient_name'] ?? 'Unknown';
        String latestMessage = latestMessageMap['message'] ?? '';
        final latestMessageDate = latestMessageMap['date'] ??
            ''; // Assuming date is stored as a string
        final isRead = latestMessageMap['is_read'] ??
            false; // Assuming is_read is stored as a boolean
        latestMessage = EncryptionService.shared.decrypt(latestMessage);

        // Creating a new ChatSummary object
        chats.add(ChatSummary(
          id: key,
          recipientEmail: value['recipient_email'] ?? '',
          recipientName: recipientName,
          latestMessage: latestMessage,
          latestMessagedate: latestMessageDate,
          isRead: isRead,
        ));
      });

      return chats;
    });
  }

  // static Future<void> initializeConversationInFirebase(
  //     String conversationId, String senderEmail, String recipientEmail) async {
  //   DatabaseReference conversationRef =
  //       _dbRef.child('conversation_threads/$conversationId');
  //   await conversationRef.set({
  //     "messages":
  //         {}, // Initialize messages as an empty object or your desired initial structure
  //     // Include additional initialization data as necessary
  //   });
  // }

  static void saveUserDatatoSharedPreference(String uid, String email) async {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.reference().child('user-data');

    DatabaseEvent dataSnapshot = await dbRef.child(uid).once();

    String firstName =
        dataSnapshot.snapshot.child('first_name').value.toString();
    String lastName = dataSnapshot.snapshot.child('last_name').value.toString();
    String role = dataSnapshot.snapshot.child('user_role').value.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String newEmail = convertToHyphenSeparatedEmail(email);

    print(firstName);
    print(lastName);
    print(role);
    print(email);
    print(newEmail);
    await prefs.setString('uid', uid);
    await prefs.setString('first_name', firstName);
    await prefs.setString('last_name', lastName);
    await prefs.setString('role', role);
    await prefs.setString('email', email);
  }

  static String convertToHyphenSeparatedEmail(String email) {
    // Replace special characters with hyphen
    String sanitizedEmail = email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '-');

    // Convert to lowercase
    sanitizedEmail = sanitizedEmail.toLowerCase();

    return sanitizedEmail;
  }

//   void saveDailyCheckInForm(Map<int, String> answers) async {
//     final currentEmail = await SharedPreferences.getInstance().then(
//       (prefs) => prefs.getString('email'),
//     );

//     if (currentEmail == null) {
//       return;
//     }

//     final currentUserEmail = DatabaseManager.safeEmail(currentEmail);

//     final dateFormatter = DateFormat('yyyyMMdd');
//     final currentDate = dateFormatter.format(DateTime.now());

//     final dailyCheckInRef = FirebaseDatabase.instance.reference().child(
//           'patient_data/$currentUserEmail/dailycheckin/$currentDate',
//         );

//     final convertedAnswers = <String, String>{};
//     answers.forEach((questionNumber, answer) {
//       final key = questionNumber.toString();
//       convertedAnswers[key] = answer;
//     });

//     final completedDateString = DateFormat.custom(
//             dateStyle: DateStyle.medium, timeStyle: TimeStyle.none)
//         .format(DateTime.now());
//     convertedAnswers['date'] = completedDateString;

//     await dailyCheckInRef.set(convertedAnswers);
//   }
}
