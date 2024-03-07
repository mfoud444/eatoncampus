import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        padding: const EdgeInsets.all(13),
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Text(
          errorMessage,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
