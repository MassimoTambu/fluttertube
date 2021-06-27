import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:url_launcher/url_launcher.dart';

class FTSearchElement extends StatelessWidget {
  FTSearchElement(this.result, this.setMediaId);

  final SearchResult result;
  final void Function(String?) setMediaId;

  void _fetchStreamInfo(BuildContext context, SearchResult result) {
    this.setMediaId(result.id!.videoId);
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
                onTap: () => onOpenYoutubeApp(context, result.id!.videoId),
                child: Row(
                  children: [
                    Image(
                      height: 50,
                      image: NetworkImage(result.snippet!.thumbnails!.medium!.url!),
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
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
                            result.snippet!.title!,
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

  void onOpenYoutubeApp(BuildContext context, String? videoId) async {
    final url = 'https://www.youtube.com/watch?v=$videoId';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
