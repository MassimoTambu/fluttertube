import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertube/state/app_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DownloadTab extends StatefulWidget {
  @override
  _DownloadTabState createState() => _DownloadTabState();
}

class _DownloadTabState extends State<DownloadTab>
    with AutomaticKeepAliveClientMixin {
  bool _audioOnly = false;
  bool _dowloading = false;
  String _searchUrl = '';
  Stream<List<int>> stream;
  yt.Video _videoInfo;
  yt.StreamInfo _selectedStream;
  String mediaId;
  String id;
  String path;

  @override
  bool get wantKeepAlive => true;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    if (Provider.of<AppState>(context).mediaId != mediaId) {
      mediaId = Provider.of<AppState>(context).mediaId;
      if (mediaId != null) {
        _searchUrl = "https://www.youtube.com/watch?v=$mediaId";
        onSubmit(_searchUrl);
      }
    }
  }

  onChangeSwitch(bool audioOnly) {
    setState(() {
      _audioOnly = audioOnly;
      _selectedStream = null;
    });
  }

  void onSubmit(String url) async {
    setState(() {
      _dowloading = true;
    });
    try {
      final yte = yt.YoutubeExplode();
      _videoInfo = await yte.videos.get(url);
      id = _videoInfo.id.toString();
      Provider.of<AppState>(context, listen: false).media =
          await yte.videos.streamsClient.getManifest(id);
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

  void _download(yt.StreamInfo download) async {
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

      final yte = yt.YoutubeExplode();

      final stream = yte.videos.streamsClient.get(download);

      // Open a file for writing.
      var fileStream = file.openWrite();

      // Pipe all the content of the stream into the file.
      await stream.pipe(fileStream);

      // Close the file.
      await fileStream.flush();
      await fileStream.close();

      yte.close();
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

  List<Widget> _createMuxedList() {
    final map = Provider.of<AppState>(context, listen: false)
        .media
        .muxed
        .sortByVideoQuality()
        .reversed
        .map<Widget>((v) {
      return Row(
        children: <Widget>[
          Radio(
            value: v,
            groupValue: _selectedStream,
            onChanged: (StreamInfo value) {
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
    final map = Provider.of<AppState>(context, listen: false)
        .media
        .audio
        .sortByBitrate()
        .reversed
        .map<Widget>((a) {
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
        color: Theme.of(context).primaryColor,
        child: Text(
          'Scarica',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed:
            _selectedStream == null ? null : () => _download(_selectedStream),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Container(
          padding: const EdgeInsets.all(12),
          child: ListView(
            physics: const BouncingScrollPhysics(),
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
                    onPressed: () => onSubmit(_searchUrl),
                  )
                ],
              ),
              if (appState.media != null)
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      children: <Widget>[
                        Text(
                          _videoInfo.title,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text('Durata: ' +
                            (new RegExp(r"(.+)\.\d+$"))
                                .firstMatch(_videoInfo.duration.toString())
                                .group(1)),
                      ],
                    ),
                  ),
                ),
              if (appState.media != null)
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
              if (appState.media != null)
                Column(
                  children:
                      _audioOnly ? _createAudioList() : _createMuxedList(),
                ),
              if (_dowloading)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(child: CircularProgressIndicator()),
                )
            ],
          ),
        );
      },
    );
  }
}
