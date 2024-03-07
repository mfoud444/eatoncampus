import 'package:construction/admin/screens/HomeScreenAdmin.dart';
import 'package:construction/common/screens/auth/SignUpScreen.dart';
import 'package:construction/models/organize.dart';
import 'package:construction/models/person.dart';
import 'package:construction/organize/screens/HomeScreenOrgnize.dart';
import 'package:construction/common/screens/AccountInactiveScreen.dart';
import 'package:construction/services/userService.dart';
import 'package:construction/person/screens/HomeScreenPerson.dart';
import 'package:flutter/material.dart';
import 'package:construction/common/screens/auth/LoginScreen.dart';
import 'package:construction/common/colors.dart';

class SplashScreenPage extends StatelessWidget {
  UserService userService = UserService();

  Future<bool> isActive(String userType) async {
    switch (userType) {
      case 'builder':
      case 'contractor':
        final Person person = await userService.getDataUsers();
        return person.isActive;
      case 'admin':
        return true;
      case 'market':
      case 'factory':
        final Organize restaurant = await userService.getDataUsers();
        return restaurant.isActive;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: userService.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    child: Image.asset('images/logo.png'),
                  ),
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                  ),
                  const SizedBox(height: 40),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      // ignore: prefer_const_constructors
                      child: Center(
                        child: const Text(
                          'App Constructors',
                          style: TextStyle(
                            fontSize: 17,
                            color: secondaryColor,
                            fontFamily: 'Times new roman',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            // User is logged in
            final String userType = snapshot.data!['type'];
            return FutureBuilder<bool>(
              future: isActive(userType),
              builder: (context, activeSnapshot) {
                if (activeSnapshot.connectionState == ConnectionState.waiting) {
                  // ignore: prefer_const_constructors
                  return Center(
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                    ),
                  );
                }
                if (userType == 'builder' || userType == 'contractor') {
                  final bool isActive = activeSnapshot.data!;

                  if (isActive) {
                    return const HomeScreenPerson();
                  } else {
                    return AccountInactiveScreen();
                  }
                } else if (userType == 'market' || userType == 'factory') {
                  final bool isActive = activeSnapshot.data!;

                  if (isActive) {
                    return const HomeScreenOrgnize();
                  } else {
                    return AccountInactiveScreen();
                  }
                } else if (userType == 'admin') {
                  return const HomeScreenAdmin();
                } else {
                  return const SignUpScreen();
                }
              },
            );
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
