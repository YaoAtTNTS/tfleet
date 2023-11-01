

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get_connect/http/src/_http/_io/_file_decoder_io.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/driver/gps_data.dart';
import 'package:tfleet/model/driver/notifiable_pickup_point_list.dart';
import 'package:tfleet/model/driver/pickup_point.dart';
import 'package:tfleet/model/driver/student_name_card_data.dart';
import 'dart:math';

import 'package:tfleet/model/driver/trip.dart';
import 'package:tfleet/model/geo_coordinates.dart';
import 'package:tfleet/model/passenger/child.dart';
import 'package:tfleet/service/driver/gps_service.dart';
import 'package:tfleet/service/driver/pickup_point_service.dart';
import 'package:tfleet/service/driver/trip_service.dart';
import 'package:tfleet/service/passenger/attendance_service.dart';
import 'package:tfleet/utils/active_trip.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/utils/system_params.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/utils/toast.dart';
import 'package:tfleet/view/driver/app/trip_summary_page.dart';
import 'package:tfleet/view/driver/component/pickup_point_card.dart';

class TripActionPage extends StatefulWidget {
  const TripActionPage({Key? key, required this.trip}) : super(key: key);
  
  final Trip trip;

  @override
  State<TripActionPage> createState() => _TripActionPageState();
}

class _TripActionPageState extends State<TripActionPage> {

  late NotifiablePickupPointList _notifiablePickupPointList;

  int _totalPPCount = 0;
  int _donePPCount = 0;

  // bool _isFirstTimeIn = false;
  // bool _isFirstTimeOut = false;
  bool _isAtPickupPoint = false;

  Timer? _timer;

  FlutterTts flutterTts = FlutterTts();
  final StringBuffer _announcement = StringBuffer();

  int pupInRange = /*SystemParams.instance.get('pup_in_range') ??*/ 30000;
  int pupOutRange = /*SystemParams.instance.get('pup_out_range') ??*/ 60;

  @override
  void initState() {
    super.initState();
    _getPickupPointList();
    _startTimer();
    _getLatestAttendances();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _getPickupPointList() async {
      _notifiablePickupPointList = NotifiablePickupPointList(pickupPoints: ActiveTrip.instance.pickupPoints);
      _notifiablePickupPointList.addPickupPoint(PickupPoint(id: 0, routeNo: '', lat: 0, lon: 0, name: '', students: [], eta: 0, type: 0, school: ''));
      _notifiablePickupPointList.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
      Global.absentIds.clear();
      _totalPPCount = ActiveTrip.instance.pickupPoints.length;
      _announcement.clear();
      _updatePickupPoint(_notifiablePickupPointList.getPickupPoint(0));
      // _checkDelay(_notifiablePickupPointList.getPickupPoint(0).eta_in_seconds);
    // setState(() {});
  }

  Future _getLatestAttendances() async {
    List attendances = await AttendanceService.getAttendancesOfTrip(widget.trip.id);
    for (Map<String, dynamic> attendance in attendances) {
      Global.studentsAttendanceStatus[attendance['childId']] = attendance['status'];
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _updatePickupPoint (PickupPoint pickupPoint) {
    Global.studentsAtCurrentPickupPoint.clear();
    List jsonList = pickupPoint.students;
    // _announcement.write(pickupPoint.name);
    _announcement.write('Please ${pickupPoint.type == 1 ? 'check' : 'remind'} ');
    for (var element in jsonList) {
      if (element['leaveStart']==null && element['leaveEnd'] == null) {
        _announcement.write(element['name']);
        _announcement.write(', ');
      }
      Global.studentsAtCurrentPickupPoint.add(Child.fromJson(element));
    }
    // if (Global.studentsAtCurrentPickupPoint.isEmpty) {
    //   if (_notifiablePickupPointList.isNotEmpty()) {
    //     _notifiablePickupPointList.removeTopPickupPoint();
    //     _updatePickupPoint(_notifiablePickupPointList.getPickupPoint(0));
    //     _checkDelay(_notifiablePickupPointList.getPickupPoint(0).eta);
    //   } else {
    //     _stopTimer();
    //   }
    // }
    _announcement.write(pickupPoint.type == 1 ? ' onboard.' : ' alight.');
  }

  // Get user current location
  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.checkPermission().then((value) async => {
      if (value != LocationPermission.always && value != LocationPermission.whileInUse) {
        await Geolocator.requestPermission().then((value){
        }).onError((error, stackTrace) async {
          await Geolocator.requestPermission();
        })
      }
    });
    return await Geolocator.getCurrentPosition();
  }

  // Convert coordinates to address
  Future<Placemark?> _addressFromCoordinates(Position pos) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    return placemarks[0];
  }

  int _checkDistance(double lat1, double lon1, double lat2, double lon2) {
    double a,b,sa2,sb2;
    sa2 = sin(_rad(lat1 - lat2) / 2.0);
    sb2 = sin(_rad(lon1 - lon2) / 2.0);
    a = sin(sa2) * sin(sa2)
        + cos(_rad(lat1)) * cos(_rad(lat2))
            * sin(sb2) * sin(sb2);
    b = 2 * atan2(sqrt(a), sqrt(1 - a));
    int d = (6378137 * b).toInt();
    // print('Distance is $d m');
    return d;
  }

  double _rad(double d) {
    return d * pi / 180.0;

  }

  Future _speak(String announcement) async{
    if (widget.trip.type > 1 && _notifiablePickupPointList.getPickupPoint(0).type == 1) {
      return;
    } else if (widget.trip.type == 1 && _notifiablePickupPointList.getPickupPoint(0).type == 2) {
      return;
    }
    var result = await flutterTts.speak(announcement);
    // if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  void _uploadGps () async {
    Position currentPos = await _getUserCurrentLocation();

    if (Global.remainingPups.isEmpty) {
      return;
    }

    int distance2pp = _checkDistance(currentPos.latitude, currentPos.longitude, Global.remainingPups[0].lat, Global.remainingPups[0].lon,);

    // TODO
    // Below is for production environment
    if (_isAtPickupPoint) {
      if (distance2pp > pupOutRange) {
        _isAtPickupPoint = false;
        _donePPCount++;
        int status = 0;
        // int absentCount = 0;
        int count = 0;
        for (Child element in Global.studentsAtCurrentPickupPoint) {
          if (Global.absentIds.contains(element.id)) {
            continue;
          }
          if (element.leaveType == null) {
            if (/*element.isAbsent*/ Global.studentsAttendanceStatus[element.id] == -1) {
              // absentCount++;
            } else {
              count++;
            }
          } else if (element.leaveType == 1) {
            if (widget.trip.type == 2) {
              if (/*!element.isAbsent*/ Global.studentsAttendanceStatus[element.id] != -1) {
                count++;
              }
            }
          }
        }
        Map<String, dynamic> params = <String, dynamic> {};
        params['id'] = widget.trip.id;
        params['count'] = count;
        if (_notifiablePickupPointList.getPickupPoint(0).students.isEmpty) {
          if (widget.trip.type == 1) {
            widget.trip.boardPax += count;
            status = 12;
            await TripService.updateOnboard(params);
          } else {
            widget.trip.alightPax += count;
            status = 11;
            await TripService.updateAlight(params);
          }
          List studentsUpdateAtSchool = await AttendanceService.saveSchoolPupAttendance(widget.trip.routeId, status);
          for (String id in studentsUpdateAtSchool) {
            Global.studentsAttendanceStatus[int.parse(id)] = status;
          }
        } else {
          if (_notifiablePickupPointList.getPickupPoint(0).type == 1) {
            widget.trip.boardPax += count;
            status = 11;
            await TripService.updateOnboard(params);
          } else {
            widget.trip.alightPax += count;
            status = 12;
            await TripService.updateAlight(params);
          }
          await AttendanceService.saveAttendances(Global.studentsAtCurrentPickupPoint, widget.trip.id, widget.trip.type, _notifiablePickupPointList.getPickupPoint(0).id.toString(),
              widget.trip.routeNo, status);
        }

        // if (absentCount > 0) {
        //   params['count'] = absentCount;
        //   await TripService.updateAbsence(params);
        // }

        _notifiablePickupPointList.removeTopPickupPoint();
        Global.remainingPups.removeAt(0);
        if (_notifiablePickupPointList.length() > 1) {
          _updatePickupPoint(_notifiablePickupPointList.getPickupPoint(0));
          _checkDelay(_notifiablePickupPointList.getPickupPoint(0).eta);
        } else {
          _stopTimer();
        }
        print('Exit pup');
      }
    } else {
      if (distance2pp < pupInRange) {
        _isAtPickupPoint = true;
        _speak(_announcement.toString());
        _announcement.clear();
        print('Enter pup');
      } else {
        if (_checkRemainingPup(currentPos.latitude, currentPos.longitude)) {
          _isAtPickupPoint = true;
          _speak(_announcement.toString());
          _announcement.clear();
          print('Skip pup');
        }
      }
    }
    GpsData data0 = GpsData(
      lon: currentPos.longitude,
      lat: currentPos.latitude,
      tripId: widget.trip.id,
    );
    GpsService.uploadGpsData(data0);
    return;
    // Below is for testing only
    if (distance2pp < 100000) {
      _isAtPickupPoint = false;
      _speak(_announcement.toString());
      _announcement.clear();
      _donePPCount++;
      int count = 0;
      int absentCount = 0;
      int status = 0;
      for (Child element in Global.studentsAtCurrentPickupPoint) {
        if (Global.absentIds.contains(element.id)) {
          continue;
        }
        if (element.leaveType == null) {
        /*  if (element.isAbsent) {
            absentCount++;
          } else {
            count++;
          }*/
        } else if (element.leaveType == 1) {
          if (widget.trip.type == 2) {
        /*    if (!element.isAbsent) {
              count++;
            }*/
          }
        }
      }
      Map<String, dynamic> params = <String, dynamic> {};
      params['id'] = widget.trip.id;
      params['count'] = count;
      if (_notifiablePickupPointList.getPickupPoint(0).type == 1) {
        widget.trip.boardPax += count;
        status = 11;
        await TripService.updateOnboard(params);
      } else {
        widget.trip.alightPax += count;
        status = 12;
        await TripService.updateAlight(params);
      }
      if (absentCount > 0) {
        params['count'] = absentCount;
        await TripService.updateAbsence(params);
      }
      // if (widget.trip.type == 1) {
      //   if (idx < _totalPPCount -1) {
      //     widget.trip.boardPax += count;
      //     status = 11;
      //     await TripService.updateOnboard(params);
      //   } else{
      //     widget.trip.alightPax += count;
      //     status = 12;
      //     await TripService.updateAlight(params);
      //   }
      // } else {
      //   if (idx == 0) {
      //     widget.trip.boardPax += count;
      //     status = 11;
      //     await TripService.updateOnboard(params);
      //   } else{
      //     status = 12;
      //     widget.trip.alightPax += count;
      //     await TripService.updateAlight(params);
      //   }
      // }
      await AttendanceService.saveAttendances(Global.studentsAtCurrentPickupPoint, widget.trip.id, widget.trip.type, _notifiablePickupPointList.getPickupPoint(0).id.toString(),
          widget.trip.routeNo, status);
      _notifiablePickupPointList.removeTopPickupPoint();
      Global.remainingPups.removeAt(0);
      if (_notifiablePickupPointList.isNotEmpty()) {
        _updatePickupPoint(_notifiablePickupPointList.getPickupPoint(0));
        _checkDelay(_notifiablePickupPointList.getPickupPoint(0).eta);
      } else {
        _stopTimer();
      }
    }
    GpsData data = GpsData(
        lon: currentPos.longitude,
        lat: currentPos.latitude,
        tripId: widget.trip.id,
    );
    GpsService.uploadGpsData(data);
  }

  bool _checkRemainingPup(double currentLat, double currentLon) {
    int length = Global.remainingPups.length;
    for (int i = 1; i < length; i++) {
      if (_checkDistance(currentLat, currentLon, Global.remainingPups[i].lat, Global.remainingPups[i].lon) < pupInRange) {
        GeoCoordinates currentGeo = Global.remainingPups[i];
        Global.remainingPups.removeAt(i);
        Global.remainingPups.insert(0, currentGeo);
        _notifiablePickupPointList.movePickupPointToTop(i);
        _updatePickupPoint(_notifiablePickupPointList.getPickupPoint(0));
        return true;
      }
    }
    return false;
  }

  void _startTimer () {
    const Duration duration = Duration(seconds: 5);
    _timer = Timer.periodic(duration, (timer) {
      _uploadGps();
    });
  }

  void _stopTimer () {
    _timer?.cancel();
    _timer = null;
  }

  void _checkDelay(int eta) async {
    int hour = DateTime.now().hour;
    int minute = DateTime.now().minute;
    int delay = hour*60 + minute - eta;
    if (delay > 15){
      await TripService.notifyDelay(widget.trip.id, _notifiablePickupPointList.getRemainingPickupPointIds(), widget.trip.type, delay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: kToolbarHeight,),
          Text(
              AppLocalizations.of(context)?.attendance ?? 'Attendance',
            style: const TextStyle(
              color: Color(0xff030303),
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'Raleway',
            ),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Text(
              '${widget.trip.departure ?? 'Unknown'} to ${widget.trip.destination ?? 'Unknown'}',
              softWrap: true,
              style: const TextStyle(
                  color: Color(0xff39393a),
                  fontSize: 16,
                  fontFamily: 'Lexend',
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              // margin: EdgeInsets.only(top: 10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _notifiablePickupPointList.length(),
                // ignore: missing_return
                itemBuilder: (BuildContext context, int index) {
                  if (_notifiablePickupPointList.getPickupPoint(index).id == 0) {
                    return GestureDetector(
                      onTap: () {
                        if (_donePPCount >= _totalPPCount) {
                          _endTrip(false);
                        } else {
                          showConfirmDialog(context);
                        }
                      },
                      child: Container(
                        height: 56,
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xffE40947),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text(
                              'End Trip',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lexend Deca',
                                fontSize: 16
                              ),
                            ),
                          ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      PickupPointCard(pickupPoint: _notifiablePickupPointList.getPickupPoint(index), isAtTop: index==0, tripType: widget.trip.type, tripId: widget.trip.id, adjustment: widget.trip.adjustment, ),
                      SizedBox(height: fitSize(20)),
                    ],
                  );
                },
              )
            ),
          ),
        ],
      ),
    );
  }

  _endTrip(bool hasRemaining) {
    Map<String, dynamic> params = <String, dynamic>{};
    params['id'] = widget.trip.id;
    params['status'] = 4;
    params['endedAt'] = DateTime.now();
    if (hasRemaining) {
      StringBuffer buffer = StringBuffer();
      for (PickupPoint pup in _notifiablePickupPointList.pickupPoints) {
        buffer.write(pup.name);
        buffer.write(':');
        List<int> ids = [];
        for (var stu in pup.students) {
          if (Global.absentIds.contains(stu['id'])) {
            continue;
          }
          ids.add(stu['id']);
        }
        buffer.write(ids.join(';'));
        buffer.write('|');
      }
      params['remaining'] = buffer.toString();
      // print('What is remaining...${buffer.toString()}');
    }
    TripService.updateTrip(params);
    _stopTimer();
    widget.trip.endedAt = DateTime.now();
    Global.absentIds.clear();
    if (mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => TripSummaryPage(trip: widget.trip,))
      );
    }
  }

  Future<bool?> showConfirmDialog(BuildContext buildContext) async {
    return showDialog<bool>(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'You have not completed all the stops, confirm to end this trip?',
            style: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)?.yes ?? 'Yes', style: TextStyle(fontSize: fitSize(40))),
              onPressed: () async {
                Navigator.of(context).pop();
                _endTrip(true);
              },
            ),
          ],
        );
      },
    );
  }

}
