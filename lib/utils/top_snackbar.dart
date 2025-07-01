import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

/// Shows a message bar sliding down from the top.
void showTopSnackbar(
  BuildContext context, {
  required String message,
  Color backgroundColor = Colors.green,
  Duration duration = const Duration(seconds: 3),
}) {
  Flushbar(
    message: message,
    backgroundColor: backgroundColor,
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    borderRadius: BorderRadius.circular(8),
    duration: duration,
    flushbarPosition: FlushbarPosition.TOP,
  ).show(context);
}
