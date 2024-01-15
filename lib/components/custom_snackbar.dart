import 'package:flutter/material.dart';

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(fontSize: 15),
    ),
    backgroundColor: Colors.green.shade600,
    elevation: 5,
    margin: const EdgeInsets.only(left: 15, right: 80, bottom: 20),
    behavior: SnackBarBehavior.floating,
    shape: const StadiumBorder(),
    action: SnackBarAction(
        label: "Dismiss", textColor: Colors.red.shade900, onPressed: () {}),
  ));
}
