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
  bool _audioOnly = false;
  bool _dowloading = false;
  Stream<List<int>> stream;
  List<yt.AudioStreamInfo> bitrates;
  List<yt.MuxedStreamInfo> resolutions;

  onChangeSwitch(bool audioOnly) {
    setState(() {
      _audioOnly = audioOnly;
    });
  }

  void onSubmit(String url) async {
    setState(() {
      _error = null;
      _dowloading = true;
    });
    try {
      final yte = yt.YoutubeExplode();
      final id = yt.YoutubeExplode.parseVideoId(url);
      final video = await yte.getVideoMediaStream(id);
      final dir = await getExternalStorageDirectory();
      final path = dir.path;
      File file;
      if (_audioOnly) {
        // stream = video.audio[video.audio.length - 1].downloadStream();
        bitrates = video.audio;
        file = File('$path/$id.ogg');
      } else {
        // stream = video.muxed[video.muxed.length - 1].downloadStream();
        resolutions = video.muxed;
        file = File('$path/$id.mp4');
      }
      if (await file.exists()) {
        if (!await _confirmOverride(context)) {
          return;
        }
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
    } finally {
      setState(() {
        _dowloading = false;
      });
    }
  }

  Future<bool> _confirmOverride(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Attenzione'),
              content: Text('Questo file esiste già, vuoi sovrascriverlo?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                FlatButton(
                  child: Text('Sì'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
        barrierDismissible: false);
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
          Row(
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                'Solo audio',
                style: const TextStyle(fontSize: 15),
              ),
              Switch(
                value: _audioOnly,
                onChanged: onChangeSwitch,
              ),
            ],
          ),
          if (_error != null) Text(_error),
          if (_dowloading) CircularProgressIndicator()
        ],
      ),
    );
  }
}
