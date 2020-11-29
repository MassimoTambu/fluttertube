import 'package:flutter/material.dart';
import 'package:fluttertube/screens/tabs/download_tab.dart';
import 'package:fluttertube/google_client.dart';
import 'package:fluttertube/screens/tabs/search_tab.dart';
import 'package:fluttertube/state/app_state.dart';
import 'package:fluttertube/utils.dart';
import 'package:googleapis/youtube/v3.dart' as yt;
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Flutter Youtube Downloader',
        theme: buildThemeData(),
        home: DefaultTabController(
          length: 2,
          child: MyHomePage(title: 'Youtube Downloader 👨🏽‍💻'),
        ),
      ),
    );
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

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        Provider.of<AppState>(context, listen: false).mediaId = null;
      }
    });
  }

  void search(String text) async {
    setState(() {
      _isLoading = true;
    });
    final ytClient = yt.YoutubeApi(client);
    try {
      var response = await ytClient.search
          .list('snippet', q: text, type: 'video', maxResults: 10);

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
    Provider.of<AppState>(context, listen: false).mediaId = mediaId;
    _tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        children: [
          SearchTab(
            isLoading: _isLoading,
            errorMessage: _errorMessage,
            search: search,
            response: _response,
            setMediaId: setMediaId,
          ),
          DownloadTab(),
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
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Theme.of(context).accentColor,
      ),
    );
  }
}
