import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_view/models/file_model.dart';
import 'package:pdf_view/page_view.dart';
import 'package:pdf_view/widgets/open_button_widget.dart';
import 'package:pdf_view/widgets/preview_pdf_file.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'bloc/main_page_bloc.dart';
import 'bloc/main_page_event.dart';
import 'bloc/main_page_state.dart';

MainPageBloc _blocChat(BuildContext context) {
  return BlocProvider.of<MainPageBloc>(context);
}

class FileHandlerScreen extends StatelessWidget {
  const FileHandlerScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainPageBloc>(
        create: (context) => MainPageBloc()..add(FileGetRecentEvent()),
        child: FileHandlerScreenFlow());
  }
}

class FileHandlerScreenFlow extends StatefulWidget {
  @override
  State<FileHandlerScreenFlow> createState() => _FileHandlerScreenState();
}

class _FileHandlerScreenState extends State<FileHandlerScreenFlow> {
  late StreamSubscription _intentSub;
  final _sharedFiles = <SharedMediaFile>[];
  late List<FileModel> fileModels = [];

  @override
  void initState() {
    super.initState();

    // Listen to media sharing coming from outside the app while the app is in the memory.
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);
        if (_sharedFiles.isNotEmpty && _sharedFiles.last.path.isNotEmpty) {
          _blocChat(context).add(FileOpenedOutDeviceEvent(
              file: FileModel(
            path: _sharedFiles.last.path,
            name: _sharedFiles.last.path.split('.').last,
          )));
        }
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      setState(() {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);
        if (_sharedFiles.isNotEmpty && _sharedFiles.last.path.isNotEmpty) {
          _blocChat(context).add(FileOpenedOutDeviceEvent(
              file: FileModel(
            path: _sharedFiles.last.path,
            name: _sharedFiles.last.path.split('.').last,
          )));
        }
        // Tell the library that we are done processing the intent.
        ReceiveSharingIntent.instance.reset();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Недавнее')),
      backgroundColor: Colors.white,
      body: BlocConsumer<MainPageBloc, FileState>(
        listener: (context, state) {
          if (state is FileOpenedState) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PageViewPdf(
                      pathFileInDevice: state.filePath,
                    )));
          }
          if (state is FileLoadedResentState) {
            fileModels = state.files;
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              if (state is FileOpenedLoadingState) CircularProgressIndicator(),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: List.generate(fileModels.length + 1, (i) {
                        if (i == 0) {
                          return OpenButtonWidget(onTap: (FileModel file) {
                            _blocChat(context).add(FileOpenedOutDeviceEvent(file: file));
                          });
                        } else {
                          return PreviewPdfFileWidget(
                            onTap: () {
                              _blocChat(context)
                                  .add(FileOpenedInDeviceEvent(file: fileModels[i - 1]));
                            },
                            file: fileModels[i - 1],
                          );
                        }
                      }))),
            ],
          );
        },
      ),
    );
  }
}
