import 'package:flutter/material.dart';

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(fontSize: 14),
    ),
    backgroundColor: Colors.green.shade600,
    elevation: 5,
    margin: const EdgeInsets.all(16),
    behavior: SnackBarBehavior.floating,
    shape: const StadiumBorder(),
    action: SnackBarAction(
        label: "Dismiss", textColor: Colors.red.shade900, onPressed: () {}),
  ));
}
