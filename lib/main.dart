import 'package:flutter/material.dart';
import 'package:fluttertube/settings/themes.dart';
import 'package:fluttertube/state/app_state.dart';
import 'package:fluttertube/ui/screens/homepage.dart';
import 'package:provider/provider.dart';

void main() => runApp(FTApp());

class FTApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'We We Uagliò',
        theme: FTThemes.buildThemeData(),
        home: HomePageScreen(),
      ),
    );
  }
}
