

import 'package:flutter/material.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/model/passenger/child.dart';
import 'package:tfleet/model/passenger/leave.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/view/passenger/app/leave_apply_page.dart';

class LeaveCard extends StatelessWidget {
  const LeaveCard({Key? key, required this.leave}) : super(key: key);

  final Leave leave;

  String _convertLeaveType(int type) {
    switch (type) {
      case 1:
        return 'ECA';
      case 2:
        return 'Holiday';
      case 3:
        return 'MC';
      case 4:
        return 'Pickup';
      case 5:
        return 'Sending';
      default:
        return '';
    }
  }

  Widget _leave() {
    return Text(
      _convertLeaveType(leave.type),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: 'Lexend Deca',
        fontSize: 16,
        color: Color(0xffF52C65),
      ),
    );
  }

  Widget _date() {
    String start = dateToAlphaMonth(leave.start.toLocal().toIso8601String());
    String end = dateToAlphaMonth(leave.end.toLocal().toIso8601String());
    return Text(
      start == end ? start : '$start to $end',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: 'Lexend Deca',
        fontSize: 16,
        color: Color(0xff030303),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width*0.8,
      padding: const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: const Color(0xfff0f0f0),
          borderRadius: BorderRadius.circular(18)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _leave(),
          _date(),
        ],
      ),
    );
  }
}
