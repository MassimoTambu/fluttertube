import 'package:flutter/cupertino.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class AppState with ChangeNotifier {
  String? _mediaId;
  StreamManifest? _media;

  String? get mediaId => _mediaId;
  StreamManifest? get media => _media;

  set mediaId(String? mediaId) {
    _mediaId = mediaId;
    notifyListeners();
  }

  set media(StreamManifest? media) {
    _media = media;
    notifyListeners();
  }
}
