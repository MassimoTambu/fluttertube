import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showSnackBar(BuildContext context, {String message}) {
    final sb = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(milliseconds: 2000),
      backgroundColor: Theme.of(context).accentColor,
    );

    Scaffold.of(context).showSnackBar(sb);
  }
}
