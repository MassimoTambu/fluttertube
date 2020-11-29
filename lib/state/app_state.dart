import 'package:flutter/cupertino.dart';

class AppState with ChangeNotifier {
  String _mediaId;

  String get mediaId => _mediaId;

  set mediaId(String mediaId) {
    _mediaId = mediaId;
    notifyListeners();
  }
}
