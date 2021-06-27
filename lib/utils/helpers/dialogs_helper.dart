import 'package:flutter/material.dart';

class DialogsHelper {
  static Future<void> showAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String actionText,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text(actionText),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  static Future<void> showErrorAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String actionText,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text(actionText),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static Future<bool?> showQuestionDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String actionTextRefusal,
    required String actionTextAcceptance,
    bool dismissible = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text(actionTextRefusal),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          FlatButton(
            child: Text(actionTextAcceptance),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
      barrierDismissible: dismissible,
    );
  }
}
