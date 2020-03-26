import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

class DownloadTab extends StatefulWidget {
  @override
  _DownloadTabState createState() => _DownloadTabState();
}

class _DownloadTabState extends State<DownloadTab> {
  bool _audioOnly = false;
  bool _dowloading = false;
  String _searchUrl = '';
  Stream<List<int>> stream;
  yt.MediaStreamInfoSet _media;
  yt.MediaStreamInfo _selectedStream;
  String id;
  String path;

  onChangeSwitch(bool audioOnly) {
    setState(() {
      _audioOnly = audioOnly;
    });
  }

  void onSubmit(String url) async {
    setState(() {
      _dowloading = true;
    });
    try {
      final yte = yt.YoutubeExplode();
      id = yt.YoutubeExplode.parseVideoId(url);
      _media = await yte.getVideoMediaStream(id);
      final dir = await getExternalStorageDirectory();
      path = dir.path;
      yte.close();
    } catch (e) {
      _errorDialog(context, 'Errore', e.message);
    }
    setState(() {
      _dowloading = false;
    });
  }

  void _download(yt.MediaStreamInfo download) async {
    setState(() {
      _dowloading = true;
    });
    File file;
    if (_audioOnly) {
      file = File('$path/$id.ogg');
    } else {
      file = File('$path/$id.mp4');
    }
    try {
      if (await file.exists()) {
        if (!await _confirmOverride(context)) {
          return;
        }
        file.writeAsBytesSync([]);
      }
      await for (var value in download.downloadStream()) {
        await file.writeAsBytes(value, mode: FileMode.append);
      }
    } catch (e) {
      _errorDialog(context, 'Errore', e.message);
    } finally {
      setState(() {
        _dowloading = false;
      });
    }
  }

  Future<void> _errorDialog(
      BuildContext context, String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      barrierDismissible: false,
    );
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
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Url',
                  ),
                  onChanged: (url) {
                    _searchUrl = url;
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => onSubmit(_searchUrl),
              )
            ],
          ),
          if (_media != null)
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: <Widget>[
                    Text(
                      _media.videoDetails.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text('Durata: ' +
                        (new RegExp(r"(.+)\.\d+$"))
                            .firstMatch(_media.videoDetails.duration.toString())
                            .group(1)),
                  ],
                ),
              ),
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
          if (_audioOnly && _media != null)
            Column(
              children: _media.audio.map((a) {
                return Row(
                  children: <Widget>[
                    Radio(
                      value: a,
                      groupValue: _selectedStream,
                      onChanged: (value) {
                        setState(() {
                          _selectedStream = value;
                        });
                      },
                    ),
                    Text(
                      'Bitrate: ${a.bitrate / 1000} kb - Peso: ${a.size / 1000000} MB',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                );
              }).toList(),
            ),
          if (!_audioOnly && _media != null)
            Column(
              children: _media.muxed.map((v) {
                return Row(
                  children: <Widget>[
                    Radio(
                      value: v,
                      groupValue: _selectedStream,
                      onChanged: (value) {
                        setState(() {
                          _selectedStream = value;
                        });
                      },
                    ),
                    Text(
                        'Qualità: ${v.videoQualityLabel} - Peso: ${v.size / 1000000} MB'),
                  ],
                );
              }).toList(),
            ),
          if (_media != null)
            Align(
              alignment: Alignment.centerRight,
              child: RaisedButton(
                child: Text('Scarica'),
                onPressed: () => _download(_selectedStream),
              ),
            ),
          if (_dowloading) CircularProgressIndicator()
        ],
      ),
    );
  }
}
