import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FTFolderField extends StatelessWidget {
  final String label;
  final String path;
  final void Function(String) folderPickerOpened;

  const FTFolderField({
    Key key,
    this.label,
    this.path,
    this.folderPickerOpened,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () => _openDirPicker(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label),
              Text(path),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openDirPicker() async {
    folderPickerOpened(await FilePicker.platform.getDirectoryPath());
  }
}
