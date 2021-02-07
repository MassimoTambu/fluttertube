import 'package:flutter/material.dart';
import 'package:fluttertube/widgets/custom_scaffold.dart';

class InfoPage extends StatelessWidget {
  final appVersion = "1.0.0";

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Text("Info App"),
        centerTitle: true,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildInfoDesc(context),
            buildInfoVersion(context),
          ],
        ),
      ),
    );
  }

  Widget buildInfoDesc(BuildContext context) {
    return Expanded(
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          children: [
            TextSpan(text: "Questa semplice App è stata creata da "),
            TextSpan(
              text: "Snorf",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoVersion(BuildContext context) {
    return Text("Versione App: $appVersion");
  }
}
