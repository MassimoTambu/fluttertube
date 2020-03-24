import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

class DownloadTab extends StatefulWidget {
  @override
  _DownloadTabState createState() => _DownloadTabState();
}

class _DownloadTabState extends State<DownloadTab> {
  String _error;

  void onSubmit(String url) async {
    setState(() {
      _error = null;
    });
    try {
      var yte = yt.YoutubeExplode();
      final stream = await fetchVideoAudioFromUrl(yte, url);
      final dir = await getExternalStorageDirectory();
      final path = dir.path;
      print(path);
      File file = File('$path/oof.ogg');
      if (await file.exists()) {
        file.writeAsBytesSync([]);
      }

      await for (var value in stream) {
        await file.writeAsBytes(value, mode: FileMode.append);
      }
      yte.close();
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<Stream<List<int>>> fetchVideoAudioFromUrl(
      yt.YoutubeExplode yte, String url) async {
    var videoId = yt.YoutubeExplode.parseVideoId(url);
    var video = await yte.getVideoMediaStream(videoId);
    final audio = video.audio[3].downloadStream();

    return audio;
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
          if (_error != null) Text(_error)
        ],
      ),
    );
  }
}
