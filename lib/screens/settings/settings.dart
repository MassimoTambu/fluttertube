import 'package:flutter/material.dart';
import 'package:fluttertube/screens/settings/customize_settings.dart';
import 'package:fluttertube/screens/settings/info.dart';
import 'package:fluttertube/widgets/custom_scaffold.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          ListTile(
            title: Text("Modifica le impostazioni"),
            onTap: () => _navigateToCustomizeSettingsPage(context),
          ),
          ListTile(
            title: Text("Informazioni"),
            onTap: () => _navigateToInfoPage(context),
          ),
        ],
      ),
    );
  }

  void _navigateToCustomizeSettingsPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CustomScaffold(
          appBar: AppBar(),
          child: CustomizeSettingsPage(),
        ),
      ),
    );
  }

  void _navigateToInfoPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CustomScaffold(
          appBar: AppBar(),
          child: InfoPage(),
        ),
      ),
    );
  }
}
