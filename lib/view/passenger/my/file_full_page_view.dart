

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tfleet/model/passenger/files.dart';
import 'package:tfleet/service/passenger/files_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:path_provider/path_provider.dart';

class FileFullPageView extends StatefulWidget {
  const FileFullPageView({Key? key, required this.files}) : super(key: key);

  final Files files;

  @override
  State<FileFullPageView> createState() => _FileFullPageViewState();
}

class _FileFullPageViewState extends State<FileFullPageView> {

  // String? _path;
  File? _file;
  int? _pages = 0;
  int? _currentPage = 0;
  bool _isReady = false;
  String errorMessage = '';

  OverlayEntry? actionOverlayEntry;
  bool _isOverlayOn = false;

  // ValueNotifier<String> currentProgress = ValueNotifier('0%');

  late PdfViewerController _pdfController;

  Future _readFile() async {
    await FilesService.readFiles(widget.files.id);
  }

  Future<void> _getFileFromUrl(String url) async {
    var fileName = url.substring(url.lastIndexOf('/')+1);
    try {
      var dir = await getApplicationDocumentsDirectory();
      _file = File('${dir.path}/$fileName');
      // _path = file.path;
      if (await _file!.exists()) {
        setState(() {});
        await _readFile();
      } else {
        Dio dio = Dio();
        await dio.download(
            url, _file!.path, onReceiveProgress: (received, total) async {
          if (total != -1) {
            if (received == total) {
              setState(() {});
              await _readFile();
            }
          }
        });
      }

    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pdfController = PdfViewerController();
    _getFileFromUrl(widget.files.url);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffe40947),
        title: Text(
          widget.files.title,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 20),
            child: _isReady ? Text(
              '$_currentPage / $_pages',
              style: const TextStyle(
                fontSize: 14
              ),
            ) : Container(),
          ),
        ],
      ),
      body: _file != null ? SfPdfViewer.file(
          _file!,
        enableDoubleTapZooming: true,
        controller: _pdfController,
        onDocumentLoaded: (document) {
          setState(() {
            _pages = document.document.pages.count;
            _currentPage = 1;
            _isReady = true;
          });
        },
        onDocumentLoadFailed: (failure) {
            Navigator.of(context).pop();
        },
        onPageChanged: (page) {
          setState(() {
            _currentPage = page.newPageNumber;
          });
        },
      ) : const Center(child: CircularProgressIndicator()),
    );
  }

}


