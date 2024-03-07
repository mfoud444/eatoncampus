import 'package:construction/models/admin.dart';
import 'package:construction/services/userService.dart';
import 'package:flutter/material.dart';

class MyAccountAdminScreen extends StatefulWidget {
  @override
  _MyAccountAdminScreenState createState() => _MyAccountAdminScreenState();
}

class _MyAccountAdminScreenState extends State<MyAccountAdminScreen> {
  late Admin admin;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getAdminData();
  }

  _getAdminData() async {
    try {
         final UserService userService = UserService();
      final adminData = await userService.getDataUsers();
    
    
      setState(() {
        admin = adminData;
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
                            subtitle: Text('${admin.name}')),
                        ListTile(
                            title: const Text('Email'),
                            subtitle: Text('${admin.email}')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
