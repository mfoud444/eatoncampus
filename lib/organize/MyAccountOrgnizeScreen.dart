import 'package:construction/models/organize.dart';
import 'package:construction/services/userService.dart';
import 'package:flutter/material.dart';

class MyAccountOrgnizeScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyAccountOrgnizeScreenState createState() => _MyAccountOrgnizeScreenState();
}

class _MyAccountOrgnizeScreenState extends State<MyAccountOrgnizeScreen> {
  late Organize restaurant;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getRestaurantData();
  }

  _getRestaurantData() async {
    try {
      final UserService userService = UserService();
      final restaurantData = await userService.getDataUsers();
      setState(() {
        restaurant = restaurantData;
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
                          subtitle: Text('${restaurant.name}'),
                        ),
                        ListTile(
                          title: const Text('Email'),
                          subtitle: Text('${restaurant.email}'),
                        ),
                        ListTile(
                          title: const Text('Opening Time'),
                          subtitle: Text('${restaurant.openingTime}'),
                        ),
                        ListTile(
                          title: const Text('Latitude'),
                          subtitle: Text('${restaurant.latitude}'),
                        ),
                        ListTile(
                          title: const Text('Longitude'),
                          subtitle: Text('${restaurant.longitude}'),
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
