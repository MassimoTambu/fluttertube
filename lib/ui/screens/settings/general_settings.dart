import 'package:flutter/material.dart';
import 'package:fluttertube/models/enums/local_storage_key_types.dart';
import 'package:fluttertube/ui/widgets/ft_folder_field.dart';
import 'package:fluttertube/utils/helpers/snackbar_helper.dart';
import 'package:fluttertube/utils/services/local_storage_service.dart';

class GeneralSettingsScreen extends StatefulWidget {
  @override
  _GeneralSettingsScreenState createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  String downloadDir = '';

  @override
  void initState() {
    _readAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          FTFolderField(
            label: 'Cartella dei download',
            path: downloadDir,
            folderPickerOpened: _onFolderSelected,
          ),
        ],
      ),
    );
  }

  Future<void> _readAllData() async {
    const downloadDirKey = LocalStorageKeyTypes.DownloadDir;
    final res = await LocalStorageService.getValue<String>(downloadDirKey);

    setState(() => downloadDir = res);
  }

  Future<void> _onFolderSelected(String newPath) async {
    // Nessun folder selezionato
    if (newPath == null) {
      return;
    }

    setState(() => downloadDir = newPath);

    final res = await LocalStorageService.setValue(
        LocalStorageKeyTypes.DownloadDir, newPath);

    SnackBarHelper.showSnackBar(context, text: 'Impostazione salvata!');

    if (!res) {
      throw 'Chiave non registrata correttamente';
    }
  }
}
