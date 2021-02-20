import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showSnackBar(BuildContext context, {String message}) {
    final sb = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      duration: const Duration(milliseconds: 2000),
    );

    Scaffold.of(context).showSnackBar(sb);
  }
}
