import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  void showErrorSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: duration ?? const Duration(seconds: 2),
        ),
      );
  }

  void showSuccessSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: duration ?? const Duration(seconds: 2),
        ),
      );
  }
}
