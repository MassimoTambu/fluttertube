import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

class DownloadTab extends StatefulWidget {
  @override
  _DownloadTabState createState() => _DownloadTabState();
}

class _DownloadTabState extends State<DownloadTab> {
  void onSubmit(String text) async {
    var yte = yt.YoutubeExplode();
    var video = await yte.getVideoMediaStream('uKWcIaJtS6Q');
    var stream = video.audio[3].downloadStream();

    final dir = await getExternalStorageDirectory();
    final path = dir.path;
    File file = File('$path/oof.txt');
    print(path);

    file.writeAsStringSync('contents');
    // await for (var value in stream) {
    //   await file.writeAsBytes(value, mode: FileMode.append);
    // }

    yte.close();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Url',
            ),
            onSubmitted: onSubmit,
          ),
          Text('')
        ],
      ),
    );
  }
}
