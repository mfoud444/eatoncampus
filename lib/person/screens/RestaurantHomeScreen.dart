import 'package:construction/common/colors.dart';
import 'package:construction/models/organize.dart';
import 'package:construction/person/screens/AllTables.dart';
import 'package:construction/person/screens/RestaurantDetailsScreen.dart';
import 'package:flutter/material.dart';

import 'CardScreen.dart';

class RestaurantHomeScreen extends StatefulWidget {
  final Organize restaurant;

  const RestaurantHomeScreen({Key? key, required this.restaurant})
      : super(key: key);

  @override
  _RestaurantHomeScreenState createState() =>
      _RestaurantHomeScreenState(restaurant: restaurant);
}

class _RestaurantHomeScreenState extends State<RestaurantHomeScreen> {
  final Organize restaurant;
  _RestaurantHomeScreenState({required this.restaurant});

  late int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      RestaurantDetailsScreen(restaurant: restaurant),
      // TableScreen(restaurant: restaurant),
      CardScreen(restaurant: restaurant),
    ];

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(title: Text(restaurant.name.toString())),
        body: Builder(builder: (context) {
          return Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          );
        }),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: appColor,
          selectedItemColor: secondaryColor,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: 'Restaurant',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.table_chart),
            //   label: 'Table',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Card ',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
