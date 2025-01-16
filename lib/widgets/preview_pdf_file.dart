import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_view/models/file_model.dart';

class PreviewPdfFileWidget extends StatelessWidget {
  final FileModel file;
  final void Function() onTapView;
  final void Function() onTapDelete;

  PreviewPdfFileWidget(
      {super.key, required this.file, required this.onTapView, required this.onTapDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTapView.call(),
        onLongPress: () => _showEditFileModal(context, onTapDelete),
        child: Container(
            width: (MediaQuery.of(context).size.width - 45) * (1/3),
            height: MediaQuery.of(context).size.height * 0.25 - 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Colors.black45,
                width: 1.0,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Center(
                              child: Text(
                                'PDF',
                                style: TextStyle(color: Colors.white, fontSize: 24),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                    /*
                    Container(
                      width: MediaQuery.of(context).size.width * 0.27,
                      height: 1,
                      color: Colors.black45,
                    ),*/
                    Expanded(
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          '${file.name}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      )),
                    ),
                  ],
                ),
                Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(21.0),
                      border: Border.all(
                        color: Colors.black45,
                        width: 1.0,
                      ),
                    ),
                    child: Icon(Icons.view_carousel_sharp))
              ],
            )));
  }

  void _showEditFileModal(
    BuildContext context,
    void Function() onTapDelete,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Действия с файлом",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 10),
               Expanded(
                  child: Column(
                children: [
                  InkWell(
                    onTap:() { onTapDelete.call();  Navigator.of(context).pop();},
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      child: Row(
                        children: [
                          Text('Удалить'),
                          Spacer(),
                          Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),

                  ),
                  SizedBox(
                    height: 32,
                  )
                ],
              )),
            ],
          ),
        );
      },
    );
  }
}
