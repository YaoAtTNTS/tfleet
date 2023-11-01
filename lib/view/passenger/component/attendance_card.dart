

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:tfleet/model/passenger/attendance.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/view/passenger/app/trip_details_page.dart';

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({Key? key, required this.attendance}) : super(key: key);

  final Attendance attendance;

  String _getStatusLabel() {
    switch (attendance.status) {
      case 12:
        return 'COMPLETED';
      case 11:
        return 'BOARDED';
      case 5:
        return 'DROP OFF';
      case 4:
        return 'PICKUP';
      case 3:
        return 'MC';
      case 2:
        return 'Holiday';
      case 1:
        return 'ECA';
      case 0:
        return 'PENDING';
      case -1:
        return 'Absent';
      default:
        return '';
    }
  }

  int _getLabelColorCode() {
    switch (attendance.status) {
      case 12:
        return 0xff008D41;
      case 11:
        return 0xff800000;
      case 0:
        return 0xffFFc13b;
      case -1:
        return 0xffe40947;
      default:
        return 0xff7C7C7C;
    }
  }

  String _etaToTimeString(int eta) {
    return '${eta~/60<10 ? '0':''}${eta~/60}${eta%60<10 ? '0': ''}${eta%60}hrs';
  }

  Widget _getRouteDirectionInfo() {
    return Column(
      children: [
        Text(
          attendance.routeNo.startsWith('A') ? 'To School' : 'Back Home',
          style: const TextStyle(
              color: Color(0xff222222),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Lexend'
          ),
        ),
        attendance.status == 11 ? Text(
          _etaToTimeString(attendance.estAlight ?? 0),
          style: const TextStyle(
              color: Color(0xff222222),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Lexend'
          ),
        ) : Container(),
        attendance.status == 0 ? Text(
          _etaToTimeString(attendance.estBoard ?? 0),
          style: const TextStyle(
              color: Color(0xffFF6600),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Lexend'
          ),
        ) : Container(),
      ],
    );
  }

  Widget _getBoardAlightTimeInfo(int type) {
    return Column(
      children: [
        Text(
          type == 1 ? 'Board' : 'Arrival',
          style: const TextStyle(
              color: Color(0xff7B7B7B),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Lexend'
          ),
        ),
        Text(
          attendance.status < 11 ? '' : (type == 1 ? getTimeString(attendance.actualBoard?.toLocal()) : getTimeString(attendance.actualAlight?.toLocal())),
          style: const TextStyle(
              color: Color(0xff222222),
              fontSize: 14,
              fontFamily: 'Lexend'
          ),
        )
      ],
    );
  }

  Widget _routeNo(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (attendance.status == 0 || attendance.status == 11) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TripDetailsPage(attendance: attendance,)));
        }
      },
      child: Container(
        height: 24,
        width: 60,
        decoration: BoxDecoration(
          color: const Color(0xffe40947),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          attendance.routeNo,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: 'Lexend'
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width - 40,
          alignment: Alignment.center,
          color: const Color(0xffFFF8FA),
        ),
        Positioned(
          top: -10,
            left: 10,
            child: Container(
              width: 100,
              height: 23,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(_getLabelColorCode()),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _getStatusLabel(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lexend'
                ),
              ),
            )
        ),
        Positioned(
          top: 40,
            left: 27,
            child: Row(
              children: [
                _getRouteDirectionInfo(),
                const SizedBox(width: 21,),
                _getBoardAlightTimeInfo(1),
                const SizedBox(width: 22,),
                _getBoardAlightTimeInfo(2),
              ],
            ),
        ),
        Positioned(
          top: 20,
          right: 20,
            child: _routeNo(context)
        ),
      ],

    );
  }
}
