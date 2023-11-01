

import 'package:flutter/material.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/model/driver/absence.dart';
import 'package:tfleet/model/passenger/leave.dart';
import 'package:tfleet/utils/format_utils.dart';

class AbsenceCard extends StatelessWidget {
  const AbsenceCard({Key? key, required this.absence}) : super(key: key);

  final Absence absence;

  String _convertLeaveType(int type) {
    switch (type) {
      case 1:
        return 'MC';
      case 2:
        return 'AL';
      case 3:
        return 'Others';
      default:
        return '';
    }
  }

  Widget _absence() {
    return Text(
      _convertLeaveType(absence.type),
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
    String start = dateToAlphaMonth(absence.start?.toLocal().toIso8601String());
    String end = dateToAlphaMonth(absence.end?.toLocal().toIso8601String());
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
          _absence(),
          _date(),
        ],
      ),
    );
  }
}
