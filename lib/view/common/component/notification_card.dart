

import 'package:flutter/material.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/utils/event.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/model/notification.dart' as MyNotification;
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/view/common/component/dot_notice_badge.dart';
import 'package:tfleet/view/common/notification_full_page.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({Key? key, required this.notification, }) : super(key: key);

  final MyNotification.Notification notification;

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {

  String time = '';

  Widget _title() {
    return Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      alignment: Alignment.centerLeft,
      child: Text(
        widget.notification.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontSize: 16,
            color: Color(0xff030303),
            fontWeight: FontWeight.w500,
          fontFamily: 'Lexend Deca'
        ),
      ),
    );
  }

  Widget _content() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: fitSize(20)),
        alignment: Alignment.centerLeft,
        child: Text(
          widget.notification.content,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: 14,
              color: Color(0xff7b7b7b),
              fontFamily: 'Lexend Deca'
          ),
        ),
      ),
    );
  }

  Widget _time() {
    if (widget.notification.time != null) {
      int diff = DateTime.now().difference(widget.notification.time!).inMinutes;
      if (diff < 60) {
        time = '${diff}m ago';
      } else if (diff < 144) {
        time = '${diff~/60}h ago';
      } else {
        time = getDateTimeString(widget.notification.time!);
      }
    }
    return Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      alignment: Alignment.centerRight,
      child: Text(
        time,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: fitSize(30),
          color: TColor.inactive,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NotificationFullPage(notification: widget.notification, time: time,),
        )).then((value) {
          setState(() {
            widget.notification.status = 2;
            if (Global.getRole() == 1) {
              event.emit('PASS_READ', null, null);
            }
          });
        });
      },
      child: Container(
        height: 101,
        width: width,
        margin: const EdgeInsets.only(left: 27, right: 27),
        color: const Color(0xfffff8fa),
        child: Stack(
          clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.only(left: fitSize(5), top: fitSize(40), right: fitSize(5)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _title()),
                        _time(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _content()
                  ],
                ),
              ),
              widget.notification.status == 1 ? Positioned(
                  top: -fitSize(10),
                right: -fitSize(10),
                child: const DotNoticeBadge(),
              ) : Container(),
            ]
        ),
      ),
    );
  }
}
