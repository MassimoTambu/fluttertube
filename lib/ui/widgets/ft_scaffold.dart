import 'package:flutter/material.dart';

class FTScaffold extends StatelessWidget {
  final AppBar? appBar;
  final Widget child;
  final Widget? navBar;

  const FTScaffold({this.appBar, required this.child, this.navBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: child,
      bottomNavigationBar: navBar,
    );
  }
}
