import 'package:construction/models/person.dart';
import 'package:construction/organize/chat/ConversionScreenRestaurant.dart';
import 'package:construction/services/chat_service.dart';
import 'package:construction/services/organizeService.dart';
import 'package:construction/person/screens/chat/ConversionScreen.dart';
import 'package:flutter/material.dart';

class ListChatScreenRestaurant extends StatefulWidget {
  @override
  _ListChatScreenRestaurantStates createState() =>
      _ListChatScreenRestaurantStates();
}

class _ListChatScreenRestaurantStates extends State<ListChatScreenRestaurant> {
  ChatService chatService = ChatService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<Person>>(
                stream: chatService.getListChatStudent().asStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Person student = snapshot.data![index];
                        return ListTile(
                          leading: Icon(Icons.person),
                          title: Text(student.fullName!),
                          onTap: () {
                            // Navigate to ConversionScreen for the selected student
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ConversionScreenRestaurant(
                                        student: student),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
