
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_view/models/file_model.dart';

class OpenButtonWidget extends StatelessWidget {
  final void Function(FileModel) onTap;

  OpenButtonWidget({required this.onTap});

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.single;
      print('Выбран файл: ${file.name}');
      if (file.path != null) {
        onTap(FileModel(path: file.path!, name: file.name));
      }
    } else {
      print('Файл не выбран');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => _pickFile(),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.27,
          height: MediaQuery.of(context).size.height * 0.25 - 50,
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.black45,
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text('открыть'),
          ),
        ));
  }
}
