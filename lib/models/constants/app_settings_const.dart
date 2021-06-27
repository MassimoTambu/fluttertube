import 'package:flutter/material.dart';
import 'package:fluttertube/models/classes/settings/app_setting.dart';
import 'package:fluttertube/models/classes/settings/app_setting_entity.dart';
import 'package:fluttertube/models/classes/settings/app_setting_group.dart';
import 'package:fluttertube/models/enums/local_storage_key_types.dart';

class AppSettingsConst {
  static const List<AppSetting> appSettings = [
    AppSettingGroup(
      name: 'Impostazioni generali',
      description: 'I cazzo di settaggi base',
      settings: [
        AppSettingEntity(
          lsKey: LocalStorageKeyTypes.DownloadDir,
          name: 'Cartella dei download',
        ),
        AppSettingGroup(
          name: 'Qualità audio e video',
          description:
              'Imposta la qualità audio e video predefinita che vuoi ottenere in fase di download',
          icon: Icons.queue_music,
          settings: [],
        ),
      ],
    ),
    AppSettingEntity(lsKey: LocalStorageKeyTypes.None, name: 'Informazioni'),
  ];
}
