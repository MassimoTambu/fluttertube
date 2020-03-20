import 'package:flutter/material.dart';
import 'package:fluttertube/google_client.dart';
import 'package:youtube_extractor/youtube_extractor.dart';
import 'package:googleapis/youtube/v3.dart' as yt;

var extractor = YouTubeExtractor();

void takeVideoStream() async {
  var streamInfo = await extractor.getMediaStreamsAsync('a1ExYqrBJio');
  // Print the audio stream url
  print('Audio URL: ${streamInfo.video.first.url}');
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void search(String text) async {
    print(text);
    final ytClient = yt.YoutubeApi(client);
    try {
      var response = await ytClient.search.list('snippet', q: text);

      print(response.toJson());
    } on yt.DetailedApiRequestError catch (e) {
      e.errors.forEach((error) {
        print(error.reason);
      });
    }

    // takeVideoStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Cerca',
              ),
              onChanged: search,
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 50,
                    color: Colors.amber[600],
                    child: const Center(child: Text('Entry A')),
                  ),
                  Container(
                    height: 50,
                    color: Colors.amber[500],
                    child: const Center(child: Text('Entry B')),
                  ),
                  Container(
                    height: 50,
                    color: Colors.amber[100],
                    child: const Center(child: Text('Entry C')),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchElement extends StatelessWidget {
  SearchElement(this.desc);

  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(desc));
  }
}
