import 'package:construction/common/colors.dart';
import 'package:flutter/material.dart';

class AccountInactiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset('images/logo.png'),
            ),
            const SizedBox(height: 16),
            const Text("Your an Account is inactive",
                style: TextStyle(fontSize: 22)),
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
                    'Thanks',
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
      ),
    );
  }
}
