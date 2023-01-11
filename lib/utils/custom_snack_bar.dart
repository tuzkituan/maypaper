import 'package:flutter/material.dart';
import 'package:maypaper/utils/globals.dart';

void showSnackBar(String text, String type) {
  snackbarKey.currentState?.clearSnackBars();

  Color? bgColor = Colors.blue[400];
  switch (type) {
    case 'info':
      bgColor = Colors.blue[400];
      break;
    case 'error':
      bgColor = Colors.red[400];
      break;
    case 'success':
      bgColor = Colors.green[400];
      break;
    default:
  }
  final snackBar = SnackBar(
    content: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: bgColor,
    duration: const Duration(seconds: 7),
    behavior: SnackBarBehavior.fixed,
  );

  snackbarKey.currentState?.showSnackBar(snackBar);
}
