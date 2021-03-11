import 'package:flutter/material.dart';
import 'package:fluttertube/settings/google_client.dart';
import 'package:fluttertube/state/app_state.dart';
import 'package:fluttertube/ui/screens/settings/main_settings.dart';
import 'package:fluttertube/ui/screens/tabs/download_tab.dart';
import 'package:fluttertube/ui/screens/tabs/search_tab.dart';
import 'package:fluttertube/ui/widgets/ft_scaffold.dart';
import 'package:fluttertube/utils/services/permission_service.dart';
import 'package:fluttertube/utils/services/startup_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/youtube/v3.dart' as yt;
import 'package:provider/provider.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with SingleTickerProviderStateMixin {
  yt.SearchListResponse _response;
  bool _isLoading = false;
  String _errorMessage;
  TabController _tabController;

  @override
  void initState() {
    _checkFirstRun();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        Provider.of<AppState>(context, listen: false).mediaId = null;
      }
    });

    PermissionService.getRequiredPermissions();

    super.initState();
  }

  void search(String text) async {
    setState(() {
      _isLoading = true;
    });
    final ytClient = yt.YouTubeApi(client);
    try {
      var response = await ytClient.search
          .list(['snippet'], q: text, videoType: 'video', maxResults: 10);

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
  }

  void setMediaId(String mediaId) {
    Provider.of<AppState>(context, listen: false).mediaId = mediaId;
    _tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: FTScaffold(
        appBar: AppBar(
          title: Text(
            'We We Uagli0\' ⌚',
            style: GoogleFonts.nanumPenScript(fontSize: 24),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => onInfoClick(context),
            ),
          ],
        ),
        child: TabBarView(
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
        navBar: TabBar(
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
          indicatorPadding: const EdgeInsets.all(5.0),
          indicatorColor: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  void onInfoClick(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (BuildContext context) => FTScaffold(
          appBar: AppBar(
            title: Text('Impostazioni'),
            centerTitle: true,
          ),
          child: MainSettingsScreen(),
        ),
      ),
    );
  }

  Future<void> _checkFirstRun() async {
    if (await StartupService.isFirstRun()) {
      await StartupService.writeDefaultData();
    }
  }
}
