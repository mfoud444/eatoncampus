import 'package:construction/models/organize.dart';
import 'package:construction/services/organizeService.dart';
import 'package:construction/person/screens/chat/ConversionScreen.dart';
import 'package:flutter/material.dart';

class ListChatScreenStudent extends StatefulWidget {
  @override
  _ListChatScreenStudentState createState() => _ListChatScreenStudentState();
}

class _ListChatScreenStudentState extends State<ListChatScreenStudent> {
  final OrganizeService _restaurantService = OrganizeService('build');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<Organize>>(
                stream: _restaurantService.getAllOrganizes().asStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Organize restaurant = snapshot.data![index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(restaurant.picture!),
                          ),
                          title: Text(restaurant.name!),
                          onTap: () {
                            // Navigate to ConversionScreen for the selected restaurant
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ConversionScreen(restaurant: restaurant),
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
