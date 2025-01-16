import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PageViewPdf extends StatefulWidget {
  final String pathFileInDevice;

  const PageViewPdf({super.key, required this.pathFileInDevice});

  @override
  _PageViewPdfState createState() => _PageViewPdfState();
}

class _PageViewPdfState extends State<PageViewPdf> {
  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  late bool _isVisible = true;
  String remoteFilePath = "";

  @override
  void initState() {
      fromDevice(widget.pathFileInDevice).then((f) {
        setState(() {
          remoteFilePath = f.path;
        });
      });
    super.initState();
  }

  Future<File> fromDevice(String filename) async {
    Completer<File> completer = Completer();
    try {
      File file = File("$filename");
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
        ),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: PopScope(
            canPop: true,
            onPopInvoked: (bool didPop) async {

            },
            child: remoteFilePath.isEmpty
                ? const CircularProgressIndicator()
                : Stack(
              children: [
                     PDFView(
                  filePath: remoteFilePath,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: false,
                  pageFling: true,
                  pageSnap: true,
                  defaultPage: currentPage,
                  fitPolicy: FitPolicy.BOTH,
                  preventLinkNavigation: false,
                  onRender: (_pages) {
                    setState(() {
                      pages = _pages ?? 0;
                      isReady = true;
                    });
                  },
                  onError: (error) {
                    setState(() {
                      errorMessage = error.toString();
                    });
                  },
                  onPageError: (page, error) {
                    setState(() {
                      errorMessage = '$page: ${error.toString()}';
                    });
                  },
                  onViewCreated: (PDFViewController pdfViewController) {
                    _controller.complete(pdfViewController);
                  },
                  onLinkHandler: (String? uri) {
                  },
                  onPageChanged: (int? page, int? total) {
                    setState(() {
                      currentPage = page ?? 1;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      reverseDuration: const Duration(milliseconds: 300),
                      child: !_isVisible
                          ? const SizedBox.shrink()
                          : Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: media.padding.top + 54,
                          width: media.size.width,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Container(
                            margin:
                            EdgeInsets.only(top: media.padding.top),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 15,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (Platform.isIOS) {
                                        SystemChrome
                                            .setEnabledSystemUIMode(
                                            SystemUiMode.manual,
                                            overlays: [
                                              SystemUiOverlay.top
                                            ]);
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.chevron_left,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '${currentPage + 1} из $pages',
                                    style: TextStyle(color: Colors.white,fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
