import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FTFolderField extends StatelessWidget {
  final String? label;
  final String? path;
  final void Function(String?)? folderPickerOpened;

  const FTFolderField({
    Key? key,
    this.label,
    this.path,
    this.folderPickerOpened,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label!),
      subtitle: Text(path!),
      onTap: () => _openDirPicker(),
    );
  }

  Future<void> _openDirPicker() async {
    folderPickerOpened!(await FilePicker.platform.getDirectoryPath());
  }
}
