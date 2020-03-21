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
        home: DefaultTabController(
          length: 2,
          child: MyHomePage(title: 'Flutter Demo Home Page'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  yt.SearchListResponse _response;

  bool _isLoading = false;

  void search(String text) async {
    print(text);
    if (text.length > 5) {
      setState(() {
        _isLoading = true;
      });
      final ytClient = yt.YoutubeApi(client);
      try {
        var response = await ytClient.search.list('snippet', q: text);

        setState(() {
          _isLoading = false;
          _response = response;
        });
      } on yt.DetailedApiRequestError catch (e) {
        e.errors.forEach((error) {
          print(error.reason);
        });
      }
    }
    // takeVideoStream();
  }

  List<Widget> getListChildren() {
    if (_isLoading) {
      return [
        Container(
          child: CircularProgressIndicator(
            strokeWidth: 10,
          ),
          height: 200.0,
        ),
      ];
    } else if (_response != null) {
      return _response.items.map((item) {
        return SearchElement(item);
      }).toList();
    }
    return [Container()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TabBarView(
        children: [
          Container(
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //       begin: Alignment.bottomLeft,
            //       end: Alignment.topRight,
            //       colors: [Colors.red, Colors.blue],
            //       stops: [0.2, 1]),
            // ),
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
                  child: ListView(children: getListChildren()),
                )
              ],
            ),
          ),
          Container(),
        ],
      ),
      bottomNavigationBar: TabBar(
        tabs: [
          Tab(
            icon: Icon(Icons.search),
          ),
          Tab(
            icon: Icon(Icons.file_download),
          ),
        ],
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.blueGrey[100],
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.orange,
      ),
    );
  }
}

class SearchElement extends StatelessWidget {
  SearchElement(this.result);

  final yt.SearchResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Text(result.snippet.title),
      Text(result.snippet.channelTitle),
      Text(result.snippet.publishedAt.toString()),
      // Text(icon.result.snippet.thumbnails.medium),
    ]));
  }
}
