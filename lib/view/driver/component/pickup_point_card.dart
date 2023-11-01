


import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/driver/pickup_point.dart';
import 'package:tfleet/model/driver/student_name_card_data.dart';
import 'package:tfleet/model/passenger/child.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/view/driver/component/student_card_on_pup.dart';

class PickupPointCard extends StatefulWidget {
  const PickupPointCard({Key? key, required this.pickupPoint, required this.isAtTop, required this.tripType, required this.adjustment, required this.tripId,}) : super(key: key);

  final int adjustment;
  final int tripType;
  final int tripId;
  final PickupPoint pickupPoint;
  final bool isAtTop;

  @override
  State<PickupPointCard> createState() => _PickupPointCardState();
}

class _PickupPointCardState extends State<PickupPointCard> {

  bool _isAtTop = false;

  String _etaToTimeString(int eta) {
    return '${eta~/60<10 ? '0':''}${eta~/60}:${eta%60<10 ? '0': ''}${eta%60}';
  }

  int _timeDelay(int eta) {
    int hour = DateTime.now().hour;
    int minute = DateTime.now().minute;
    return hour*60 + minute - eta;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isAtTop = widget.isAtTop;
  }

  @override
  void didUpdateWidget(PickupPointCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isAtTop != widget.isAtTop) {
      setState(() {
        _isAtTop = widget.isAtTop;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int delay = _timeDelay(widget.pickupPoint.eta);
    return Opacity(
      opacity: _isAtTop ? 1.0 : 0.5,
      child: Container(
        color: widget.pickupPoint.status == 0 ? const Color(0xffFFFFDD) : const Color(0xffD3EDC9),
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.pickupPoint.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff080A0B),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Lexend',
                    ),
                  ),
                ),
                _isAtTop ? Text(
                  '${AppLocalizations.of(context)?.eta??'ETA'}: ${_etaToTimeString(widget.pickupPoint.eta + widget.adjustment)}',
                  style: TextStyle(
                      color: delay <= 5 ? const Color(0xff008d41) : (delay <= 10 ? const Color(0xffff8552) : const Color(0xffE40947)),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lexend',
                      fontSize: 18,
                  ),
                ) : Container(),
              ],
            ),
            const SizedBox(height: 5,),
            studentList(context, widget.pickupPoint, _isAtTop),
          ],
        ),
      ),
    );
  }

  /*void _checkNAECASPSD (Child student) {
    if (!Global.presentIds.contains(student.id)) {
      if (student.leaveType != null) {
        if (student.leaveType! > 0) {
          if (widget.tripType == 2) {
            if (student.leaveType! == 1 || student.leaveType! == 5) {
              student.isECA_SP_SD = true;
              student.isAbsent = true;
              Global.updateStudentAbsence(student.id!, student.isAbsent);
            } else {
              student.isNA = true;
            }
          } else if (widget.tripType == 1) {
            if (student.leaveType! == 4) {
              student.isECA_SP_SD = true;
              student.isAbsent = true;
              Global.updateStudentAbsence(student.id!, student.isAbsent);
            } else {
              student.isNA = true;
            }
          } else {
            student.isNA = true;
          }
        } *//*else if (student.leaveType == -2) {
          student.isNA = true;
        }*//*
      }
    }
  }*/

  Widget studentList(BuildContext context, PickupPoint pickupPoint, bool isAtTop) {
    List<Child> students = [];
    List jsonList = pickupPoint.students;
    if (jsonList.isEmpty) {
      return Container(
        height: 82,
        alignment: Alignment.centerLeft,
        child: Text(
          'School: ${pickupPoint.school}',
          softWrap: true,
          style: const TextStyle(
            color: Color(0xff1E1F26),
            fontWeight: FontWeight.bold,
            fontFamily: 'Sora',
            fontSize: 18,
          ),
        ),
      ) ;
    }
    for (var element in jsonList) {
      students.add(Child.fromJson(element));
      // if (element['isAbsent'] != null && element['isAbsent']) {
      //   students.last.isAbsent = true;
      // }
      // _checkNAECASPSD(students.last);
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            children: [
              StudentCardOnPup(student: students[index], pupType: pickupPoint.type, isAtTop: _isAtTop, tripType: widget.tripType, tripId: widget.tripId,),
              Container(
                height: 5,
                color: const Color(0xffF0F0F0),
              )
            ],
          );
        },
      itemCount: students.length,
    );
  }
}

