import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  final appVersion = "1.0.0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Info App"),
        centerTitle: true,
      ),
      body: Container(
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
              text: "Massimo Tamburini",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: " e "),
            TextSpan(
              text: "Lorenzo Polverelli",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: "."),
            TextSpan(
              text:
                  "Se c'è qualcosa che non funziona o pensate siano necessarie delle migliorie segnalatelo ad uno dei due programmatori di fiducia sopra citati.",
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
