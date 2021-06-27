import 'package:flutter/material.dart';
import 'package:fluttertube/models/classes/descriptable.dart';
import 'package:fluttertube/models/classes/iconic.dart';
import 'package:fluttertube/models/classes/settings/app_setting.dart';

class AppSettingGroup implements AppSetting, Descriptable, Iconic {
  final String _name;
  final String? _description;
  final IconData? _icon;
  final List<AppSetting> settings;

  const AppSettingGroup({
    required String name,
    required this.settings,
    String? description,
    IconData? icon,
  })  : this._name = name,
        this._description = description,
        this._icon = icon;

  @override
  String get description => _description!;

  @override
  String get name => _name;

  @override
  IconData? get icon => _icon;
}
