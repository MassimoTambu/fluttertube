import 'package:flutter/foundation.dart';
import 'package:fluttertube/models/classes/descriptable.dart';
import 'package:fluttertube/models/classes/settings/app_setting.dart';
import 'package:fluttertube/models/classes/storable.dart';
import 'package:fluttertube/models/classes/settings/app_setting_handler.dart';
import 'package:fluttertube/models/enums/local_storage_key_types.dart';
import 'package:fluttertube/utils/services/local_storage_service.dart';

class AppSettingEntity
    implements AppSetting, AppSettingHandler, Storable, Descriptable {
  final LocalStorageKeyTypes _lsKey;
  final String _name;
  final String _description;
  final void Function() _onChanged;
  final void Function() _onTap;

  const AppSettingEntity({
    @required LocalStorageKeyTypes lsKey,
    @required String name,
    String description,
    void Function() onChanged,
    void Function() onTap,
  })  : this._lsKey = lsKey,
        this._name = name,
        this._description = description,
        this._onChanged = onChanged,
        this._onTap = onTap;

  @override
  LocalStorageKeyTypes get lsKey => _lsKey;

  @override
  Future<bool> save<T>(T value) async {
    return await LocalStorageService.setValue(lsKey, value);
  }

  @override
  String get name => _name;

  @override
  String get description => _description;

  @override
  void onChanged() => this._onChanged();

  @override
  void onTap() => this._onTap();
}
