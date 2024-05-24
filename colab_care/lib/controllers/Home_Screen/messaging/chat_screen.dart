import 'package:colab_care/aes.dart';
import 'package:colab_care/controllers/Themes/theme_manager.dart';
import 'package:colab_care/database_access.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final String recipientEmail;
  final String senderEmail;
  final String recipientName; // Add this line

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.recipientEmail,
    required this.senderEmail,
    required this.recipientName,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  // late final Future<List<ChatMessage>> _messagesFuture;
  late final EncryptionService _encryptionService;

  String firstName = '';
  String lastName = '';

  @override
  void initState() {
    super.initState();
    // _messagesFuture = DatabaseUtils.fetchChatMessages(widget.conversationId);
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    firstName = prefs.getString('first_name') ?? '';
    lastName = prefs.getString('last_name') ?? '';
    firstName = firstName + lastName;
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      DatabaseUtils.sendMessage(
        recipientName: firstName,
        conversationId: widget.conversationId,
        senderEmail: widget.senderEmail,
        recipientEmail: widget.recipientEmail,
        messageText: messageText,
      );
      _messageController.clear();
    }
  }

  String? decryptMessage(String encryptedMessage) {
    try {
      return _encryptionService.decrypt(encryptedMessage);
    } catch (e) {
      return "Decryption error: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    final theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.backgroundColor,
        title: Text(widget.recipientName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: DatabaseUtils.fetchChatMessages(widget.conversationId),
              // future: _messagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No messages yet");
                }
                var messages = snapshot.data!;
                messages.sort((a, b) => a.date.compareTo(b.date));

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    // Determine if the message is incoming or outgoing
                    bool isIncoming = message.recipientEmail ==
                        DatabaseUtils.convertToHyphenSeparatedEmail(
                            currentUserEmail);

                    // Decrypt the message content before displaying it
                    // Inside your ListView.builder itemBuilder:
                    String? decryptedContent =
                        EncryptionService.shared.decrypt(message.content);
                    return Align(
                      alignment: isIncoming
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: isIncoming
                              ? Colors.white
                              : theme.backgroundGradientStart,
                          borderRadius: isIncoming
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )
                              : const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                        ),
                        child:
                            Text(decryptedContent), // Display decrypted content
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
