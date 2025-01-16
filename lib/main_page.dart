import 'dart:async';

import 'package:flutter/cupertino.dart';
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
      appBar: AppBar(
          title: Row(
        children: [
          Text('Недавнее'),
          const Spacer(),
          InkWell(
            onTap: () => _showMoreInfoModal.call(context),
            child: Icon(Icons.question_mark),
          )
        ],
      )),
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
          return SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (state is FileOpenedLoadingState)
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    runAlignment: WrapAlignment.start,
                    alignment: WrapAlignment.start,
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: List.generate(fileModels.length + 1, (i) {
                      if (i == 0) {
                        return OpenButtonWidget(onTap: (FileModel file) {
                          _blocChat(context).add(FileOpenedOutDeviceEvent(file: file));
                        });
                      } else {
                        return PreviewPdfFileWidget(
                          onTapView: () {
                            _blocChat(context)
                                .add(FileOpenedInDeviceEvent(file: fileModels[i - 1]));
                          },
                          onTapDelete: () {
                            _blocChat(context).add(FileDeleteInAppEvent(file: fileModels[i - 1]));
                          },
                          file: fileModels[i - 1],
                        );
                      }
                    })),
              ),
            ],
          ));
        },
      ),
    );
  }

  void _showMoreInfoModal(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "О приложении",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Expanded(
                  child: Column(
                children: [
                  Text(
                      'На этой странице можно открыть для просмотра pdf файлы с вашего устройства.'),
                  SizedBox(height: 6),
                  Text(
                      'На этой странице отображаются pdf файлы которые когда либо были открыты через это приложение. Если по какой-либо причине раннее добавленный файл перестал отображаться в приложении, то скорее всего этот файл был удален с устройства или перемещен в другую папку, так как это приложение не хранит копию файлов, оно хранит пути к файлам которые были открыты через это приложение.'),
                  SizedBox(height: 10),
                  Text(
                      'Чтобы удалить файл из списка, нужно удерживать нажатие на иконке файла, после которого откроется модальное окно в котором можно удалить файл.\nУдаление файла не удалит файл с устройства, файл удалиться только в приложении.'),
                  SizedBox(height: 10),
                ],
              )),
            ],
          ),
        );
      },
    );
  }
}
