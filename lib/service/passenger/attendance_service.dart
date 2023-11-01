

import 'dart:convert';
import 'dart:math';

import 'package:tfleet/http/http.dart';
import 'package:tfleet/model/driver/student_name_card_data.dart';
import 'package:tfleet/model/passenger/attendance.dart';
import 'package:tfleet/model/passenger/child.dart';
import 'package:tfleet/service/passenger/leave_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';

class AttendanceService {

  static const String path = '/attendance/';

  static Future getAttendances(int userId, String date) async {
    final response = await Http.post(
        '${path}list',
        params: {
          'userId':userId,
          'date':date
        }
    );
    return response['list'];
  }

  static Future getAttendancesOfTrip (int tripId) async {
    final response = await Http.get('${path}trip/$tripId');
    return response['list'];
  }

  static Future getAttendance(int id) async {
    final response = await Http.get(
        '${path}info/$id'
    );
    return response['attendance'];
  }

  static Future deleteAttendance(List<int> ids) async {
    final response = await Http.post(
        '${path}delete',
      data: ids
    );
    return response['code'];
  }

  static Future updateIndividualAttendance(int tripId, int studentId, int status) async {
    Map<String, dynamic> params = {};
    params['childId'] = studentId;
    params['tripId'] = tripId;
    params['status'] = status;
    final response = await Http.post(
        '${path}update_individual',
        params: params
    );
    return response['code'];
  }

  static Future updateLeave (int leaveId) async {
    Map<String, dynamic> params = {};
    params['id'] = leaveId;
    params['status'] = -2;
    await LeaveService.updateLeave(params);
  }

  static Future saveSchoolPupAttendance(int routeId, int status) async {
    Map<String, dynamic> params = {};
    params['route'] = routeId;
    params['status'] = status;
    final response = await Http.post(
        '${path}saveSchool',
        params: params
    );
    return response['list'];
  }

  static Future saveAttendances(List<Child> students, int tripId, int tripType, String pupId, String routeNo, int status) async {
    List<Map<String, dynamic>> attendances = [];
    for (Child element in students) {
      int individualStatus = status;
      bool expectedAbsent = false;
      if (Global.absentIds.contains(element.id)) {
        continue;
      }

      if (tripType == 1) {
        if (element.leaveType != null) {
          if (element.leaveType! > 1 && element.leaveType! < 4) {
            individualStatus = element.leaveType!;
            Global.absentIds.add(element.id!);
          } else if (element.leaveType! == 4) {
            if (/*!element.isAbsent*/ Global.getStudentAttendanceStatus(element.id!) != -1) {
              if (element.leaveId != null) {
                await updateLeave(element.leaveId!);
                Global.presentIds.add(element.id!);
              }
            } else {
              individualStatus = element.leaveType!;
              Global.absentIds.add(element.id!);
              expectedAbsent = true;
            }
          }
        }
      } else if (tripType == 2) {
        if (element.leaveType != null) {
          if (element.leaveType == 1 || element.leaveType == 5) {
            if (/*!element.isAbsent*/ Global.getStudentAttendanceStatus(element.id!) != -1) {
              if (element.leaveId != null) {
                await updateLeave(element.leaveId!);
                Global.presentIds.add(element.id!);
              }
            } else {
              individualStatus = element.leaveType!;
              Global.absentIds.add(element.id!);
              expectedAbsent = true;
            }
          } else if (element.leaveType! < 4) {
            individualStatus = element.leaveType!;
            Global.absentIds.add(element.id!);
          }
        }
      } else {
        if (element.leaveType != null) {
          if (element.leaveType != 1 && element.leaveType! != 4) {
            individualStatus = element.leaveType!;
            Global.absentIds.add(element.id!);
          }
        }
      }

      if (!expectedAbsent) {
        if (/*element.isAbsent*/ Global.getStudentAttendanceStatus(element.id!) == -1) {
          individualStatus = -1;
          Global.absentIds.add(element.id!);
        }
      }
      Global.studentsAttendanceStatus[element.id!] = individualStatus;
      attendances.add(
          Attendance(
            userId: element.userId,
            tripId: tripId,
            routeNo: routeNo,
            childId: element.id ?? 0,
            childName: element.name,
            status: individualStatus,
            actualBoard: individualStatus == 11 ? DateTime.now() : null,
            boardPoint: individualStatus == 11 ? pupId : null,
            actualAlight: individualStatus == 12 ? DateTime.now() : null,
            alightPoint: individualStatus == 12 ? pupId : null,
          ).toJson());
    }
    final response = await Http.post(
      '${path}batch',
      data: jsonEncode(attendances)
    );
    return response['code'];
  }
}