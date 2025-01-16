
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_view/models/file_model.dart';

class OpenButtonWidget extends StatelessWidget {
  final void Function(FileModel) onTap;
  OpenButtonWidget({required this.onTap,});

  void _pickFile(BuildContext context) async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    /*
    Directory appDocDir = await Directory("storage/emulated/0");

    var result = await FilesystemPicker.open(allowedExtensions: [".pdf",],
        context: context,rootDirectory: appDocDir);
    if (result != null) {
      File file = File(result);
      print(file.parent.path);// the path where the file is saved
      onTap(FileModel(path: file.parent.path, name: file.parent.path.split('/').last));

    }

     */
    if (result != null) {
      PlatformFile file = result.files.single;
      //print('Выбран файл: ${file.name}');
      if (file.path != null) {
        onTap(FileModel(path: file.path!, name: file.path!.split('/').last));
      }
    } else {
      //print('Файл не выбран');
    }

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => _pickFile(context),
        child: Container(
          width: (MediaQuery.of(context).size.width - 45) * (1/3),
          height: MediaQuery.of(context).size.height * 0.25 - 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.redAccent,
              width: 1.0,
            ),
          ),
          child: const Center(
            child: Icon(Icons.add,size: 32,color: Colors.redAccent,),
          ),
        ));
  }
}
