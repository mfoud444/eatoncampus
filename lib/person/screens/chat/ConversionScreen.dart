import 'package:construction/models/chat.dart';
import 'package:construction/models/organize.dart';
import 'package:construction/services/chat_service.dart';
import 'package:construction/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversionScreen extends StatefulWidget {
  final Organize restaurant;
  ConversionScreen({required this.restaurant});

  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  UserService userService = UserService();
  ChatService chatService = ChatService();
  late Map<String, dynamic> currentUser;

  String? studentId;
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    currentUser = await userService.getCurrentUser();
    studentId = currentUser['id'];
    setState(() {});
  }

  Stream<List<Chat>> getAllChats() {
    return chatService.getChatStream(
        studentId: studentId!, restaurantId: widget.restaurant.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name!),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildChatList(),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_textController.text.trim().isNotEmpty) {
                      chatService.sendMessage(Chat(
                        senderId: studentId!,
                        receiverId: widget.restaurant.id!,
                        message: _textController.text,
                        type: 'text',
                        timestamp: Timestamp.now(),
                      ));
                      _textController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    if (studentId != null && widget.restaurant.id != null) {
      return StreamBuilder<List<Chat>>(
        stream: getAllChats(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Chat> _chats = snapshot.data!;
            return ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final chat = _chats[index];
                final isOwnMessage = chat.senderId == studentId;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Align(
                    alignment: isOwnMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isOwnMessage ? Colors.grey[300] : Colors.green[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        chat.message,
                        style: TextStyle(
                          color: isOwnMessage ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Not Have Conversion!!'),
            );
          }
        },
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
