import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

class DownloadTab extends StatefulWidget {
  const DownloadTab({this.mediaId});
  final String mediaId;

  @override
  _DownloadTabState createState() => _DownloadTabState();
}

class _DownloadTabState extends State<DownloadTab> {
  bool _audioOnly = false;
  bool _dowloading = false;
  String _searchUrl = '';
  Stream<List<int>> stream;
  yt.Video _videoInfo;
  yt.StreamManifest _media;
  yt.StreamInfo _selectedStream;
  String id;
  String path;

  @override
  initState() {
    super.initState();
    if (widget.mediaId != null) {
      _searchUrl = widget.mediaId;
      onSubmit(url: _searchUrl, prefix: 'https://www.youtube.com/watch?v=');
    }
  }

  onChangeSwitch(bool audioOnly) {
    setState(() {
      _audioOnly = audioOnly;
    });
  }

  void onSubmit({@required String url, String prefix}) async {
    setState(() {
      _dowloading = true;
    });
    try {
      final yte = yt.YoutubeExplode();
      _videoInfo = await yte.videos.get(url);
      id = _videoInfo.id.toString();
      _media = await yte.videos.streamsClient.getManifest(id);
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

  // void _download(yt.StreamInfo download) async {
  //   setState(() {
  //     _dowloading = true;
  //   });
  //   File file;
  //   if (_audioOnly) {
  //     file = File('$path/$id.ogg');
  //   } else {
  //     file = File('$path/$id.mp4');
  //   }
  //   try {
  //     if (await file.exists()) {
  //       if (!await _confirmOverride(context)) {
  //         return;
  //       }
  //       file.writeAsBytesSync([]);
  //     }
  //     await for (var value in download.downloadStream()) {
  //       await file.writeAsBytes(value, mode: FileMode.append);
  //     }
  //   } catch (e) {
  //     _errorDialog(context, 'Errore', e.message);
  //   } finally {
  //     setState(() {
  //       _dowloading = false;
  //     });
  //   }
  // }

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

  List<Widget> _createMuxedList() {
    final map = _media.muxed.map<Widget>((v) {
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
              'Qualità: ${v.videoQualityLabel} - Peso: ${v.size.totalMegaBytes.toStringAsFixed(2)} MB'),
        ],
      );
    }).toList();

    map.add(_getDownloadButton());

    return map;
  }

  List<Widget> _createAudioList() {
    final map = _media.audio.map<Widget>((a) {
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
            'Bitrate: ${a.bitrate.kiloBitsPerSecond.round()} kbps - Peso: ${a.size.totalMegaBytes.toStringAsFixed(2)} MB',
            style: TextStyle(fontSize: 13),
          ),
        ],
      );
    }).toList();

    map.add(_getDownloadButton());

    return map;
  }

  Widget _getDownloadButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: RaisedButton(
        child: Text('Scarica'),
        onPressed: () {},
        // onPressed: () => _download(_selectedStream),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: ListView(
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
                  controller: TextEditingController(text: _searchUrl),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => onSubmit(url: _searchUrl),
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
                      _videoInfo.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text('Durata: ' +
                        (new RegExp(r"(.+)\.\d+$"))
                            .firstMatch(_videoInfo.duration.toString())
                            .group(1)),
                  ],
                ),
              ),
            ),
          if (_media != null)
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
          if (_media != null)
            Column(
              children: _audioOnly ? _createAudioList() : _createMuxedList(),
            ),
          if (_dowloading) CircularProgressIndicator()
        ],
      ),
    );
  }
}
