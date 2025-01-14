

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_view/models/file_model.dart';

class PreviewPdfFileWidget extends StatelessWidget {
  final FileModel file;
  final void Function() onTap;
  const PreviewPdfFileWidget({super.key, required this.file,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap.call(),
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
            child: Text('${file.name}'),
          ),
        ));
  }
}
