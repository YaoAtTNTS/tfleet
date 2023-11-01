

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/model/notification.dart' as my_notification;
import 'package:tfleet/service/notification_service.dart';
import 'package:tfleet/utils/global.dart';

class NotificationFullPage extends StatefulWidget {
  const NotificationFullPage({Key? key, required this.notification, required this.time}) : super(key: key);

  final my_notification.Notification notification;
  final String time;
  @override
  State<NotificationFullPage> createState() => _NotificationFullPageState();
}

class _NotificationFullPageState extends State<NotificationFullPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.notification.id == 0) {
      Global.updateUnread(-1);
      Global.readWelcomeMsg();
    } else if (widget.notification.status == 1) {
      Global.updateUnread(-1);
      NotificationService.read(widget.notification.id);
    }
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 100,),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Text(
                widget.notification.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Text(widget.time),
          ),
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Text(
              widget.notification.content,
              style: const TextStyle(
                fontSize: 14
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
      height: width * 0.568,
      // margin: const EdgeInsets.only(top: kToolbarHeight),
      padding: const EdgeInsets.only(left: 42, right: 42),
      decoration: BoxDecoration(
          color: const Color(0xffe40947),
          borderRadius: BorderRadius.circular(18)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.white,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Details',
                style: TextStyle(
                    fontSize: 24,
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
