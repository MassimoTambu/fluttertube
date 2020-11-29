import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';

class SearchTab extends StatelessWidget {
  final bool isLoading;
  final String errorMessage;
  final SearchListResponse response;
  final void Function(String) search;
  final void Function(String) setMediaId;

  const SearchTab({
    @required this.isLoading,
    @required this.errorMessage,
    @required this.search,
    @required this.setMediaId,
    @required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Cerca',
              ),
              onSubmitted: search,
            ),
          ),
          buildSearchResults(context),
        ],
      ),
    );
  }

  Widget buildSearchResults(BuildContext context) {
    Widget child;

    if (isLoading) {
      child = Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (response != null) {
      child = Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: response.items.length,
          itemBuilder: (context, index) {
            return getListChildren(index);
          },
        ),
      );
    } else if (response == null) {
      child = Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_video,
              size: 80,
              color: Theme.of(context).accentColor,
            ),
            Text(
              'Nessuna ricerca effettuata',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      );
    } else {
      throw 'Not Implemented';
    }

    return child;
  }

  Widget getListChildren(int index) {
    if (response != null && errorMessage == null) {
      return SearchElement(response.items[index], setMediaId);
    } else if (errorMessage != null) {
      return Container(child: Text(errorMessage));
    }

    throw 'Not implemented';
  }
}

class SearchElement extends StatelessWidget {
  SearchElement(this.result, this.setMediaId);

  final SearchResult result;
  final void Function(String) setMediaId;

  void _fetchStreamInfo(BuildContext context, SearchResult result) {
    this.setMediaId(result.id.videoId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 5),
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
            color: Theme.of(context).accentColor,
            onPressed: () => _fetchStreamInfo(context, result),
          ),
        ],
      ),
    );
  }
}
