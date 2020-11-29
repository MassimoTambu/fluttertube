import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:url_launcher/url_launcher.dart';

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
      // CHECK IF IS EMPTY RESULT
      if (response.items.length == 0) {
        child = Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "🤷🏽‍♀️",
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 10),
              const Text(
                'Nessun risultato',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      } else {
        child = Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: response.items.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Questi sono i primi 10 risultati trovati:"),
                    const SizedBox(height: 10),
                    getListChildren(index),
                  ],
                );
              }
              return getListChildren(index);
            },
          ),
        );
      }
    } else if (response == null) {
      child = Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "🕵🏽‍♂️",
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 10),
            const Text(
              'Nessuna ricerca effettuata',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
          Expanded(
            child: Tooltip(
              message: "Guarda su Youtube App",
              child: InkWell(
                onTap: () => onOpenYoutubeApp(context, result.id.videoId),
                child: Row(
                  children: [
                    Image(
                      height: 50,
                      image: NetworkImage(result.snippet.thumbnails.medium.url),
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
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
                  ],
                ),
              ),
            ),
          ),
          Tooltip(
            message: "Scarica",
            child: IconButton(
              icon: Icon(
                Icons.file_download,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () => _fetchStreamInfo(context, result),
            ),
          ),
        ],
      ),
    );
  }

  void onOpenYoutubeApp(BuildContext context, String videoId) async {
    final url = 'https://www.youtube.com/watch?v=$videoId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
