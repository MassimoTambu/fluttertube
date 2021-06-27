import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showSnackBar(
    BuildContext context, {
    required String text,
    Duration? duration,
    SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating,
    // da sistemare
    AnimationController? animationController,
  }) {
    duration ??= const Duration(milliseconds: 2000);
    final sb = SnackBar(
      content: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      animation: animationController != null
          ? Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: animationController, curve: Curves.easeInOut),
            )
          : null,
      backgroundColor: Theme.of(context).primaryColor,
      duration: duration,
      behavior: snackBarBehavior,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(sb);
  }
}
