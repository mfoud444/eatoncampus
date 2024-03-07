import 'package:construction/models/chat.dart';
import 'package:construction/models/organize.dart';
import 'package:construction/models/person.dart';
import 'package:construction/services/chat_service.dart';
import 'package:construction/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversionScreenRestaurant extends StatefulWidget {
  final Person student;
  ConversionScreenRestaurant({required this.student});

  @override
  _ConversionScreenRestaurantState createState() =>
      _ConversionScreenRestaurantState();
}

class _ConversionScreenRestaurantState
    extends State<ConversionScreenRestaurant> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  UserService userService = UserService();
  ChatService chatService = ChatService();
  Map<String, dynamic>? currentUser;

  String? restaurantId1;
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    currentUser = await userService.getCurrentUser();

    setState(() {
      restaurantId1 = currentUser!['id'];
    });
  }

  Stream<List<Chat>> getAllChats() {
    return chatService.getChatStream(
        studentId: widget.student.id!, restaurantId: restaurantId1!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student.fullName!),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildChatList(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_textController.text.trim().isNotEmpty) {
                      chatService.sendMessage(Chat(
                        senderId: restaurantId1!,
                        receiverId: widget.student.id!,
                        message: _textController.text,
                        type: 'text',
                        timestamp: Timestamp.now(),
                      ));
                      _textController.clear();
                      getAllChats();
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
    if (restaurantId1 != null && widget.student.id != null) {
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
                final isOwnMessage = chat.senderId == restaurantId1;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Align(
                    alignment: isOwnMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
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
                        style: const TextStyle(
                          color: Colors.black,
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
