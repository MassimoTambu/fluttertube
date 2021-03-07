import 'package:flutter/material.dart';
import 'package:fluttertube/models/classes/ft_downloader.dart';
import 'package:fluttertube/models/enums/file_format_types.dart';
import 'package:fluttertube/state/app_state.dart';
import 'package:fluttertube/utils/helpers/dialogs_helper.dart';
import 'package:fluttertube/utils/helpers/snackbar_helper.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

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
  yt.StreamInfo _selectedStream;
  String mediaId;
  final ftDownloader = FTDownloader();

  @override
  bool get wantKeepAlive => true;

  @override
  didChangeDependencies() {
    if (Provider.of<AppState>(context).mediaId != mediaId) {
      mediaId = Provider.of<AppState>(context).mediaId;
      if (mediaId != null) {
        _searchUrl = "https://www.youtube.com/watch?v=$mediaId";
        onSubmit(_searchUrl);
      }
    }

    super.didChangeDependencies();
  }

  onChangeSwitch(bool audioOnly) {
    setState(() {
      if (audioOnly) {
        ftDownloader.audioFormat = AudioFormatTypes.Mp3;
        ftDownloader.videoFormat = null;
      } else {
        ftDownloader.audioFormat = null;
        ftDownloader.videoFormat = VideoFormatTypes.Ogg;
      }
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

      ftDownloader.videoInfo = await yte.videos.get(url);
      ftDownloader.streamManifest =
          await yte.videos.streamsClient.getManifest(ftDownloader.videoInfo.id);

      yte.close();
    } catch (e) {
      DialogsHelper.showErrorAlertDialog(
        context,
        title: 'Errore',
        content: e.toString(),
        actionText: 'Okay',
      );
    } finally {
      setState(() {
        _dowloading = false;
      });
    }
  }

  void _download(context, yt.StreamInfo selectedStream) async {
    await ftDownloader.download(
      streamToDownload: selectedStream,
      context: context,
      onInitDownload: () => setState(() => _dowloading = true),
      onEndDownload: () {
        setState(() => _dowloading = false);
        SnackBarHelper.showSnackBar(context, text: 'Download Completato!');
      },
    );
  }

  List<Widget> _createMuxedList(BuildContext context) {
    final map = ftDownloader.streamManifest.muxed
        .sortByVideoQuality()
        .reversed
        .map<Widget>((v) {
      return Row(
        children: <Widget>[
          Radio(
            value: v,
            groupValue: _selectedStream,
            onChanged: (yt.StreamInfo value) {
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

    map.add(_getDownloadButton(context));

    return map;
  }

  List<Widget> _createAudioList(BuildContext context) {
    final map = ftDownloader.streamManifest.audio
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

    map.add(_getDownloadButton(context));

    return map;
  }

  Widget _getDownloadButton(BuildContext context) {
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
        onPressed: _selectedStream == null
            ? null
            : () => _download(context, _selectedStream),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
          if (ftDownloader.streamManifest != null)
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: <Widget>[
                    Text(
                      ftDownloader.videoInfo.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text('Durata: ' +
                        (new RegExp(r"(.+)\.\d+$"))
                            .firstMatch(
                                ftDownloader.videoInfo.duration.toString())
                            .group(1)),
                  ],
                ),
              ),
            ),
          if (ftDownloader.streamManifest != null)
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
          if (ftDownloader.streamManifest != null)
            Column(
              children: _audioOnly
                  ? _createAudioList(context)
                  : _createMuxedList(context),
            ),
          if (_dowloading)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(child: CircularProgressIndicator()),
            )
        ],
      ),
    );
  }
}
