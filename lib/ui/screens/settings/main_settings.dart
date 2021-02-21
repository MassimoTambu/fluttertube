import 'package:flutter/material.dart';
import 'package:fluttertube/ui/screens/settings/general_settings.dart';
import 'package:fluttertube/ui/screens/settings/info.dart';
import 'package:fluttertube/ui/widgets/ft_scaffold.dart';

class MainSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          ListTile(
            title: Text("Impostazioni generali"),
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
        builder: (context) => FTScaffold(
          appBar: AppBar(
            title: Text('Impostazioni generali'),
            centerTitle: true,
          ),
          child: GeneralSettingsScreen(),
        ),
      ),
    );
  }

  void _navigateToInfoPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FTScaffold(
          appBar: AppBar(
            title: Text('Info App'),
            centerTitle: true,
          ),
          child: InfoScreen(),
        ),
      ),
    );
  }
}
