

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/model/passenger/files.dart';
import 'package:tfleet/service/passenger/files_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/view/feedback/page_feedback.dart';
import 'package:tfleet/view/passenger/component/files_card.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({Key? key}) : super(key: key);

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {

  final List<Files> _filesList = [];

  int _outstanding = 0;

  late EasyRefreshController _easyRefreshController;

  bool loading = true;
  bool error = false;
  bool replace = true;
  bool hasMore = true;
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
    // _getFilesList();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  Future _onRefresh() async {
    _filesList.clear();
    await _getFilesList();
    if (error) {
      setState(() => error = false);
    }
    _easyRefreshController.resetLoadState();
  }

  Future _onLoad() async {
   // if (hasMore) {
   // }
    //_easyRefreshController.finishLoad(noMore: !hasMore);
  }

  Future _getFilesList() async {
    Map<String, dynamic> params = {};
    params['ownerId'] = Global.getUserId()!;
    var files = await FilesService.getFiles(params: params);
    for (Map<String, dynamic> filesJson in files) {
      Files files = Files.fromJson(filesJson);
      if (files.status == 1) {
        _outstanding++;
      }
      _filesList.add(files);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _onDelete(Files files) {
    setState(() {
      _filesList.remove(files);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Padding(
              padding: EdgeInsets.only(left: 40, top: 20, right: 40, bottom: 20),
            child: Text(
              _filesList.isNotEmpty ? 'History of payments' : 'You don\'t have any payment records.',
              style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Lexend Deca',
                  fontWeight: FontWeight.w500,
                  color: Color(0xff030303)
              ),
            ),
          ),
          Expanded(
            child: EasyRefresh(
              firstRefresh: true,
              firstRefreshWidget: PageFeedBack(firstRefresh: true).build(),
              emptyWidget: PageFeedBack(
                loading: loading,
                error: error,
                empty: _filesList.isEmpty,
                errorMsg: errorMsg,
                onErrorTap: () => {} /*_easyRefreshController.callRefresh()*/,
                onEmptyTap: () => {} /*_easyRefreshController.callRefresh()*/,
              ).build(),
              footer: ClassicalFooter(),
              controller: _easyRefreshController,
              enableControlFinishRefresh: false,
              enableControlFinishLoad: true,
              onRefresh: _onRefresh,
              //onLoad: _onLoad,
              child: ListView.builder(
                itemCount: _filesList.length,
                // controller: _scrollController,
                // ignore: missing_return
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      SizedBox(height: fitSize(20)),
                      FilesCard(files: _filesList[index], onDelete: _onDelete,)
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: width,
      height: width * 0.28,
      padding: const EdgeInsets.only(left: 20, right: 42),
      decoration: BoxDecoration(
          color: const Color(0xffe40947),
          borderRadius: BorderRadius.circular(18)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 20),
              child: Text(
                _outstanding == 0 ? 'All your payment are on time.\nthank you' :
                'Your have $_outstanding payment(s) due',
                style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Lexend Deca',
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
