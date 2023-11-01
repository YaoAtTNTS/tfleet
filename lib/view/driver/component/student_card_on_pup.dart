

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/passenger/child.dart';
import 'package:tfleet/service/driver/trip_service.dart';
import 'package:tfleet/service/passenger/attendance_service.dart';
import 'package:tfleet/utils/constants.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/view/driver/component/student_profile.dart';

class StudentCardOnPup extends StatefulWidget {
  const StudentCardOnPup({Key? key, required this.student, required this.pupType, required this.isAtTop, required this.tripType, required this.tripId,}) : super(key: key);

  final Child student;
  final int tripType;
  final int tripId;
  final int pupType;
  final bool isAtTop;

  @override
  State<StudentCardOnPup> createState() => _StudentCardOnPupState();
}

class _StudentCardOnPupState extends State<StudentCardOnPup> {

   String _getLeaveType(int? type) {
    switch (type) {
      case 0:
        return 'Pending';
      case 1:
        return 'ECA';
      case 2:
        return 'Holiday';
      case 3:
        return 'MC';
      case 4:
        return 'No Pickup';
      case 5:
        return 'No Dropoff';
      case 11:
        return 'Boarded';
      case 12:
        return 'Alighted';
      case -1:
        return 'Absent';
      case -2:
        return 'Other Bus';
      default:
        return '  ';
    }
  }

  Widget _avatar() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => StudentProfile(child: widget.student)
            )
        );
      },
      child: Container(
        width: fitSize(150),
        height: fitSize(150),
        decoration: BoxDecoration(
          color: TColor.page,
          borderRadius: BorderRadius.circular(fitSize(100)),
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            placeholder: (context, url) => SizedBox(
              width: fitSize(125),
              height: fitSize(125),
              child: const Center(child: CircularProgressIndicator()),
            ),
            imageUrl: widget.student.url ?? Constants.PROFILE_IMAGE_DEFAULT_URL,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  int _getColorCode(int status) {
     switch (status) {
       case 0:
         return 0xffFFc13b;
       case 1:
       case 2:
       case 3:
       case 4:
       case 5:
       case -2:
         return 0xff7B7B7B;
       case 11:
         return 0xff800000;
       case 12:
         return 0xff008D41;
       case -1:
         return 0xffE40947;
       default:
         return 0xff7C7C7C;
     }
  }

  Widget _presenceLabel(int status) {
    // _initData();
    return Container(
      height: 20,
      width: 76,
      decoration: BoxDecoration(
          color: Color(_getColorCode(status)),
          borderRadius: BorderRadius.circular(5)
      ),
      alignment: Alignment.center,
      child: Text(
        _getLeaveType(status),
        style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.bold
        ),
      ),
    );
    if (widget.student.isNA || widget.student.isECA_SP_SD) {
      return Container(
        height: 20,
        width: 76,
        decoration: BoxDecoration(
            color: const Color(0xff7B7B7B),
            borderRadius: BorderRadius.circular(5)
        ),
        alignment: Alignment.center,
        child: Text(
          _getLeaveType(widget.student.leaveType),
          style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.bold
          ),
        ),
      );
    }
    /*if (widget.student.isAbsent) {
      return Container(
        height: 20,
        width: 76,
        decoration: BoxDecoration(
            color: const Color(0xffE40947),
            borderRadius: BorderRadius.circular(5)
        ),
        alignment: Alignment.center,
        child: const Text(
          'Absent',
          style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.bold
          ),
        ),
      );
    }*/
    return Container(
      height: 20,
      width: 76,
      decoration: BoxDecoration(
          color: const Color(0xff008D41),
          borderRadius: BorderRadius.circular(5)
      ),
      alignment: Alignment.center,
      child: Text(
        widget.pupType == 1 ? 'On Board' : 'Alight',
        style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  /*void _initData() {
    if (!Global.presentIds.contains(widget.student.id)) {
      if (widget.student.leaveType != null) {
        if (widget.student.leaveType! > 0) {
          if (widget.tripType == 2) {
            if (widget.student.leaveType! == 1 || widget.student.leaveType! == 5) {
              _isECA_SP_SD = true;
              widget.student.isAbsent = true;
            } else {
              _isNA = true;
            }
          } else if (widget.tripType == 1) {
            if (widget.student.leaveType! == 4) {
              _isECA_SP_SD = true;
              widget.student.isAbsent = true;
            } else {
              _isNA = true;
            }
          } else {
            _isNA = true;
          }
        } else if (widget.student.leaveType == -2) {
          _isNA = true;
        }
      }
    }
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int status = Global.getStudentAttendanceStatus(widget.student.id!);

    return Row(
      children: [
        SizedBox(
          width: 88,
          height: 82,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _avatar(),
              Align(
                alignment: Alignment.bottomCenter,
                child: _presenceLabel(status),
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            widget.student.name,
            softWrap: true,
            style: const TextStyle(
                color: Color(0xff1E1F26),
                fontWeight: FontWeight.bold,
                fontFamily: 'Sora',
                fontSize: 14,
            ),
          ),
        ),
        /*widget.student.isNA*/ (status > 1 && status < 6) ? Container() : GestureDetector(
          onTap: () {
            showConfirmDialog(context);
          },
          child: Container(
            color: /*widget.student.isAbsent*/ (status == -1) ? const Color(0xff008D41) : const Color(0xffE40947),
            height: 82,
            width: 59,
            child: Center(
              child: Icon(
                /*widget.student.isAbsent*/ (status == -1) ? Icons.event_available : Icons.event_busy,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ) ;
  }

  Future<bool?> showConfirmDialog(BuildContext buildContext) async {
    return showDialog<bool>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)?.confirmStudentAbsent ?? 'Confirm this passenger is absent or onboard ?',
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)?.cancel ?? "Cancel", style: TextStyle(fontSize: fitSize(40))),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)?.yes ??'Yes', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () async {
                Map<String, dynamic> params = <String, dynamic> {};
                params['id'] = widget.tripId;
                setState(() {
                  if (Global.getStudentAttendanceStatus(widget.student.id!) == -1) {
                    Global.studentsAttendanceStatus[widget.student.id!] = 11;
                    params['count'] = -1;
                  } else {
                    Global.studentsAttendanceStatus[widget.student.id!] = -1;
                    params['count'] = 1;
                  }
                  // widget.student.isAbsent = !widget.student.isAbsent;
                  // Global.updateStudentAbsence(widget.student.id!, widget.student.isAbsent);
                });
                Navigator.of(context).pop();
                await AttendanceService.updateIndividualAttendance(widget.tripId, widget.student.id!, Global.studentsAttendanceStatus[widget.student.id!]!);
                await TripService.updateAbsence(params);
              },
            ),
          ],
        );
      },
    );
  }
}
