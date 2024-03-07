import 'package:construction/models/person.dart';
import 'package:construction/services/userService.dart';
import 'package:flutter/material.dart';

class MyAccountStudentScreen extends StatefulWidget {
  @override
  _MyAccountStudentScreenState createState() => _MyAccountStudentScreenState();
}

class _MyAccountStudentScreenState extends State<MyAccountStudentScreen> {
  late Person student;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getStudentData();
  }

  _getStudentData() async {
    try {
      final UserService userService = UserService();
      final studentData = await userService.getDataUsers();
      setState(() {
        student = studentData;
        _loading = false;
      });
    } catch (e) {
      // handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Account')),
      body: _loading
          // ignore: prefer_const_constructors
          ? Center(
              child: const CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Name '),
                          subtitle: Text('${student.fullName}'),
                        ),
                        ListTile(
                          title: const Text('Email'),
                          subtitle: Text('${student.email}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
