import 'package:construction/common/colors.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color bgColor;

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.isLoading,
    this.bgColor = bottonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        minimumSize: const Size.fromHeight(50),
      ),
      onPressed: onPressed,
      icon: isLoading
          ? Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2.0),
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : Icon(icon),
      label: Text(
        label,
        // ignore: prefer_const_constructors
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
