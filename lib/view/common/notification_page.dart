

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/service/notification_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/model/notification.dart' as myNotification;
import 'package:tfleet/view/common/component/notification_card.dart';
import 'package:tfleet/view/feedback/page_feedback.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  final List<myNotification.Notification> _notificationList = [];

  late EasyRefreshController _easyRefreshController;

  bool loading = true;
  bool error = false;
  bool empty = false;
  bool replace = true;
  bool hasMore = true;
  bool firstRefresh = true;
  String errorMsg = '';
  String emptyMsg = 'No notification yet.';

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
    // _getNotificationList();
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  Future _onRefresh() async {
    _notificationList.clear();
    await _getNotificationList();
    if (_notificationList.isEmpty) {
      if (mounted) {
        setState(() => empty = true);
      }
    }
    firstRefresh = false;
    loading = false;
    _easyRefreshController.resetLoadState();
  }

  Future _onLoad() async {
   // if (hasMore) {
   // }
    //_easyRefreshController.finishLoad(noMore: !hasMore);
  }

  Future _getNotificationList() async {
    // for(int i = 0; i<5; i++) {
    //   _notificationList.add(myNotification.Notification(
    //       id: i,
    //       title: 'Test Notification ${i + 1}',
    //       content: 'Test content ${i+1}',
    //     time: '2023-3-20 10:5$i',
    //     status: i<2? 0: 1,
    //   ));
    // }
    var notifications = await NotificationService.getNotifications(Global.getUserId()!);
    int _unread = 0;
    if (Global.welcomeMsg() != null) {
      _notificationList.add(Global.welcomeMsg()!);
      if (Global.welcomeMsg()!.status == 1) {
        _unread++;
      }
    }
    for (Map<String, dynamic> notificationJson in notifications) {
      myNotification.Notification notification = myNotification.Notification.fromJson(notificationJson);
      _notificationList.add(notification);
      if (notification.status == 1) {
        _unread++;
      }
    }
    Global.setUnread(_unread);
    if (mounted) {
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(width),
          const SizedBox(height: 29,),
          Expanded(
            child: EasyRefresh(
              firstRefresh: true,
              firstRefreshWidget: const PageFeedBack(firstRefresh: true).build(),
              emptyWidget: PageFeedBack(
                loading: loading,
                error: error,
                empty: _notificationList.isEmpty,
                errorMsg: errorMsg,
                onErrorTap: () => {} /*_easyRefreshController.callRefresh()*/,
                onEmptyTap: () => _easyRefreshController.callRefresh(),
                emptyMsg: emptyMsg
              ).build(),
              footer: ClassicalFooter(),
              controller: _easyRefreshController,
              enableControlFinishRefresh: false,
              enableControlFinishLoad: true,
              onRefresh: _onRefresh,
              // onLoad: _onLoad,
              child: ListView.builder(
                itemCount: _notificationList.length,
                // controller: _scrollController,
                // ignore: missing_return
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      const SizedBox(
                          height: 20,
                      ),
                      NotificationCard(notification: _notificationList[index], ),
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

  Widget _buildHeader(double width) {
    return Container(
      width: width,
      height: width * 0.28,
      // margin: const EdgeInsets.only(top: kToolbarHeight),
      padding: const EdgeInsets.only(left: 42, right: 42),
      decoration: BoxDecoration(
          color: const Color(0xffe40947),
          borderRadius: BorderRadius.circular(18)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.menu,
            size: 30,
            color: Colors.white,
          ),
          Expanded(
            child: Text(
              AppLocalizations.of(context)?.notification ?? 'Notification',
              style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
          ),
        ],
      ),
    );
  }
}
