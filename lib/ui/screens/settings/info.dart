import 'package:flutter/material.dart';
import 'package:fluttertube/ui/widgets/ft_rive_animation.dart';
import 'package:fluttertube/utils/helpers/app_version_helper.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          buildInfoDesc(context),
          FTRiveAnimation(fullFileName: 'assets/rive/doggo.riv'),
          buildInfoVersion(context),
        ],
      ),
    );
  }

  Widget buildInfoDesc(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
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
              TextSpan(text: ". Seguitemi su "),
              TextSpan(
                text: "Only Fanz ",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: "per supportarmi! 💖"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoVersion(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text("Versione App: ${AppVersionHelper.version}"),
    );
  }
}
