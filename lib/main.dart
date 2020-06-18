import 'package:flutter/material.dart';
import 'package:fluttertube/download_tab.dart';
import 'package:fluttertube/google_client.dart';
import 'package:fluttertube/state/app_state.dart';
import 'package:googleapis/youtube/v3.dart' as yt;
import 'package:provider/provider.dart';

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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  yt.SearchListResponse _response;
  bool _isLoading = false;
  String _errorMessage;
  TabController _tabController;
  String _mediaId;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        setState(() {
          _mediaId = null;
        });
      }
    });
  }

  void search(String text) async {
    setState(() {
      _isLoading = true;
    });
    final ytClient = yt.YoutubeApi(client);
    try {
      var response =
          await ytClient.search.list('snippet', q: text, type: 'video');

      setState(() {
        _isLoading = false;
        _response = response;
        _errorMessage = null;
      });
    } on yt.DetailedApiRequestError catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    }
    // takeVideoStream();
  }

  void setMediaId(String mediaId) {
    setState(() {
      _mediaId = mediaId;
    });
    _tabController.animateTo(1);
  }

  List<Widget> getListChildren() {
    if (_isLoading) {
      return [
        Container(
          child: CircularProgressIndicator(),
        ),
      ];
    } else if (_response != null && _errorMessage == null) {
      return _response.items.map((item) {
        return SearchElement(item, setMediaId);
      }).toList();
    } else if (_errorMessage != null) {
      return [Container(child: Text(_errorMessage))];
    }

    return [Container(child: Text('No items'))];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TabBarView(
        controller: _tabController,
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
                  onSubmitted: search,
                ),
                Expanded(
                  child: ListView(children: getListChildren()),
                )
              ],
            ),
          ),
          DownloadTab(mediaId: _mediaId)
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
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
  SearchElement(this.result, this.setMediaId);

  final yt.SearchResult result;
  final void Function(String) setMediaId;

  void _fetchStreamInfo(BuildContext context, yt.SearchResult result) {
    this.setMediaId(result.id.videoId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (context) => AppState(),
      child: Container(
        height: 50,
        child: Row(
          children: <Widget>[
            Image(
              height: 50,
              image: NetworkImage(result.snippet.thumbnails.medium.url),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    result.snippet.title,
                    style: TextStyle(fontSize: 11),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.file_download),
              color: Colors.blue,
              onPressed: () => _fetchStreamInfo(context, result),
            ),
          ],
        ),
      ),
    );
  }
}
