import 'package:flutter/material.dart';
import 'package:youtube_extractor/youtube_extractor.dart';

var extractor = YouTubeExtractor();

void takeVideoStream() async {}

class DownloadTab extends StatefulWidget {
  @override
  _DownloadTabState createState() => _DownloadTabState();
}

class _DownloadTabState extends State<DownloadTab> {
  void onSubmit() async {
    var streamInfo = await extractor.getMediaStreamsAsync('a1ExYqrBJio');
    // Print the audio stream url
    print('Audio URL: ${streamInfo.video.first.url}');

    Text(streamInfo.video.first.url);
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
            // onSubmitted: ,
          ),
        ],
      ),
    );
  }
}
