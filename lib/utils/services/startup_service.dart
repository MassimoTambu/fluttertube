import 'dart:io';

import 'package:fluttertube/models/enums/local_storage_key_types.dart';
import 'package:fluttertube/utils/services/local_storage_service.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

class StartupService {
  static Future<bool> isFirstRun() async {
    const firstRunKey = LocalStorageKeyTypes.FirstRun;

    if (await LocalStorageService.containsKey(firstRunKey)) {
      print('FIRST RUN: false');
      return false;
    }

    print('FIRST RUN: true');
    return true;
  }

  static Future<void> writeDefaultData() async {
    const firstRunKey = LocalStorageKeyTypes.FirstRun;
    const downloadDirKey = LocalStorageKeyTypes.DownloadDir;

    String path;

    if (Platform.isAndroid) {
      path = (await pathProvider.getDownloadsDirectory())!.path;
    } else if (Platform.isIOS) {
      path = (await pathProvider.getApplicationDocumentsDirectory()).path;
    } else {
      throw 'Not Supported Platform for get default download Dir';
    }

    final res = [
      await LocalStorageService.setValue(firstRunKey, false),
      await LocalStorageService.setValue(downloadDirKey, path)
    ];

    if (res.firstWhere((r) => r == false, orElse: () => false)) {
      throw 'Key not registered correctly';
    }
  }
}
