

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tfleet/model/driver/absence.dart';
import 'package:tfleet/model/driver/trip.dart';
import 'package:tfleet/model/user.dart';
import 'package:tfleet/service/driver/absence_service.dart';
import 'package:tfleet/service/driver/trip_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/view/common/profile_image.dart';
import 'package:tfleet/view/passenger/component/leave_card.dart';
import 'package:tfleet/view/subcon/component/absence_card.dart';
import 'package:tfleet/view/subcon/component/missed_trip_card.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({Key? key, required this.user, required this.type}) : super(key: key);

  final int type;
  final User user;

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {

  final List<Trip> _upcomingTripList = [];
  final List<Absence> _absenceList = [];

  bool _isShowingTrips = false;
  bool _isShowingAbsence = true;

  Future _getAbsenceList() async {
    List<Map<String, dynamic>> absences;
    if (widget.user.role == 2) {
      absences = await AbsenceService.getDriverAbsences(widget.user.id!);

    } else {
      absences = await AbsenceService.getAttendanceAbsences(widget.user.id!);
    }
    for (Map<String, dynamic> absenceJson in absences) {
      Absence absence = Absence.fromJson(absenceJson);
      _absenceList.add(absence);
    }
  }

  Future _getTripList() async {
    Map<String, dynamic> params = <String, dynamic>{};
    if (widget.user.role == 2) {
      params['driverId'] = Global.getUserId();
    } else {
      params['attendantId'] = Global.getUserId();
    }
    params['statuses'] = jsonEncode([1,2,3]);
    String today = dateToAlphaMonth(DateTime.now().toString());
    var trips = await TripService.getTrips(params: params);
    for (Map<String, dynamic> tripJson in trips) {
      Trip trip = Trip.fromJson(tripJson);
      trip.date = dateToAlphaMonth(tripJson['plannedStart']);
      if (trip.date == today) {
        trip.date = 'Today, $today';
      }
      _upcomingTripList.add(trip);
    }
    if (_upcomingTripList.isNotEmpty) {
      if (_upcomingTripList[0].date.contains('Today')) {
        _upcomingTripList[0].todayHasTrip = 1;
      } else {
        _upcomingTripList.insert(0, Trip(id: 0, type: 0, plannedPax: 0, boardPax: 0, alightPax: 0, routeId: 0, routeNo: '', startLat: 0, startLon: 0,
            departure: '', endLat: 0, endLon: 0, destination: '', createdAt: null, plannedStart: null, plannedEnd: null, endedAt: null, status: 0, adjustment: 0));
        _upcomingTripList[0].todayHasTrip = 0;
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTripList();
    _getAbsenceList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kToolbarHeight,),
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.user.name,
                    style: const TextStyle(
                        color: Color(0xff030303),
                        fontSize: 24,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Colors.black,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Center(child: ProfileImage(size: 297, url: widget.user.url)),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: _normalText('${widget.type == 1 ? 'Driver' : 'Attendant'} '),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: _iconAndTitle(Icons.phone, 'Mobile No:  ${widget.user.account}'),
            ),
            // SizedBox(height: 20,),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20.0, right: 20),
            //   child: _tripTitle(),
            // ),
            // SizedBox(height: 10,),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20.0, right: 20),
            //   child: _tripListView(),
            // ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: _absenceTitle(),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: _absenceListView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tripTitle() {
    return Row(
      children: [
        const Text(
          'Upcoming Trips',
          style: TextStyle(
              color: Color(0xff030303),
              fontSize: 18,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.bold
          ),
        ),
        TextButton(
            onPressed: () {
              // setState(() {
              //   _isShowingTrips = !_isShowingTrips;
              // });
            },
            child: Text(
              _isShowingTrips ? 'Fold' : 'Show all',
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.bold
              ),
        ))
      ],
    );
  }

  Widget _tripListView() {
    return _isShowingTrips ? ListView.builder(
      shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index){
        Absence absence = _absenceList[index];
          return Row(
            children: [
              Text(absence.type.toString()),
              SizedBox(width: 20,),
              Text(dateToAlphaMonth(absence.start?.toLocal().toString())),
              Text(' to '),
              Text(dateToAlphaMonth(absence.end?.toLocal().toString())),
            ],
          );
        }
    ) : Container();
  }

  Widget _absenceTitle() {
    return Row(
      children: [
        const Text(
          'Upcoming Absences',
          style: TextStyle(
              color: Color(0xff030303),
              fontSize: 18,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.bold
          ),
        ),
        TextButton(
            onPressed: () {
              // setState(() {
              //   _isShowingAbsence = !_isShowingAbsence;
              // });
            },
            child: Text(
              _isShowingAbsence ? 'Fold' : 'Show all',
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.bold
              ),
            )
        )
      ],
    );
  }

  Widget _absenceListView() {
    return _isShowingAbsence ? ListView.builder(
      shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index){
          return AbsenceCard(absence: _absenceList[index]);
        }
    ) : Container();
  }

  Widget _normalText(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Color(0xff030303),
          fontSize: 18,
          fontFamily: 'Lexend',
          fontWeight: FontWeight.bold
      ),
    );
  }

  Widget _iconAndTitle(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Color(0xffff6600),
          size: 24,
        ),
        SizedBox(width: 5,),
        _normalText(text),
      ],
    );
  }
}
