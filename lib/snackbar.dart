import 'package:flutter/material.dart';

void displaySnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: (Colors.blueAccent),
    action: SnackBarAction(
      textColor: Colors.white,
      label: 'dismiss',
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
