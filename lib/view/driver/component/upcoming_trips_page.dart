

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/driver/trip.dart';
import 'package:tfleet/service/driver/trip_service.dart';
import 'package:tfleet/utils/active_trip.dart';
import 'package:tfleet/utils/event.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/utils/toast.dart';
import 'package:tfleet/view/driver/app/trip_action_page.dart';
import 'package:tfleet/view/driver/component/trip_card.dart';
import 'package:tfleet/view/feedback/page_feedback.dart';

class UpcomingTripsPage extends StatefulWidget {
  const UpcomingTripsPage({Key? key, }) : super(key: key);

  @override
  State<UpcomingTripsPage> createState() => _UpcomingTripsPageState();
}

class _UpcomingTripsPageState extends State<UpcomingTripsPage> {

  bool loading = true;
  bool error = false;
  bool empty = false;
  bool replace = true;
  bool hasMore = true;
  bool firstRefresh = true;
  String errorMsg = '';

  final List<Trip> _upcomingTripList = [];

  late EasyRefreshController _easyRefreshController;

  Future _getTripList() async {

    Map<String, dynamic> params = <String, dynamic>{};
    if (Global.getRole() == 2) {
      params['driverId'] = Global.getUserId();
    } else {
      params['attendantId'] = Global.getUserId();
    }
    params['statuses'] = 1;
    DateTime now = DateTime.now();
    String today = dateToAlphaMonth(now.toString());
    var trips = await TripService.getTrips(params: params);
    for (Map<String, dynamic> tripJson in trips) {
      if (tripJson['status'] == -2) {
        continue;
      }
      Trip trip = Trip.fromJson(tripJson);
      trip.date = dateToAlphaMonth(tripJson['plannedStart']);
      if (trip.date == today) {
        trip.date = 'Today, $today';
        int diff = trip.plannedStart!.toLocal().add(Duration(minutes: trip.adjustment)).difference(now).inHours;
        if (diff < -2) {
          trip.todayHasTrip = 2;  // potentially missed trip;
        } else if (diff < 2) {
          trip.todayHasTrip = 1;  // probably can start
        }
      }
      _upcomingTripList.add(trip);
    }
    if (_upcomingTripList.isNotEmpty) {
      if (!_upcomingTripList[0].date.contains('Today')) {
        _upcomingTripList.insert(0, Trip(id: 0, type: 0, plannedPax: 0, boardPax: 0, alightPax: 0, routeId: 0, routeNo: '', startLat: 0, startLon: 0,
            departure: '', endLat: 0, endLon: 0, destination: '', createdAt: null, plannedStart: null, plannedEnd: null, endedAt: null, status: 0, adjustment: 0));
        _upcomingTripList[0].todayHasTrip = 0;
      }
    }
    if (mounted) {
      setState(() {

      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _easyRefreshController = EasyRefreshController();

    event.on('UPCOMING', (start, end) {
      if (mounted) {
        setState(() {
          if (start != null && end != null) {
            for (Trip trip in _upcomingTripList) {
              if (trip.plannedStart != null && trip.plannedStart!.isAfter(start) && trip.plannedStart!.isBefore(end)) {
                trip.visible = true;
              } else {
                trip.visible = false;
              }
            }
          } else if (start != null && end == null) {
            for (Trip trip in _upcomingTripList) {
              if (trip.plannedStart != null && trip.plannedStart!.isAfter(start)) {
                trip.visible = true;
              } else {
                trip.visible = false;
              }
            }
          } else if (start == null && end != null) {
            for (Trip trip in _upcomingTripList) {
              if (trip.plannedStart != null && trip.plannedStart!.isBefore(end)) {
                trip.visible = true;
              } else {
                trip.visible = false;
              }
            }
          } else if (start == null && end == null) {
            for (Trip trip in _upcomingTripList) {
              trip.visible = true;
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _easyRefreshController.dispose();
    super.dispose();
  }

  Future _onRefresh() async {
    _upcomingTripList.clear();
    await _getTripList();
    if (_upcomingTripList.isEmpty) {
      setState(() => empty = true);
    }
    firstRefresh = false;
    loading = false;
    _easyRefreshController.resetLoadState();
  }

  Future _onLoad() async {
   if (hasMore) {
   }
    _easyRefreshController.finishLoad(noMore: !hasMore);
  }

  void _onDelete(Trip trip) {
    setState(() {
      _upcomingTripList.remove(trip);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      firstRefresh: true,
      firstRefreshWidget: PageFeedBack(firstRefresh: true).build(),
      emptyWidget: PageFeedBack(
        loading: loading,
        error: error,
        empty: _upcomingTripList.isEmpty,
        errorMsg: errorMsg,
        onErrorTap: () => {} /*_easyRefreshController.callRefresh()*/,
        onEmptyTap: () => {} /*_easyRefreshController.callRefresh()*/,
      ).build(),
      footer: ClassicalFooter(),
      controller: _easyRefreshController,
      enableControlFinishRefresh: false,
      enableControlFinishLoad: false,
      onRefresh: _onRefresh,
      // onLoad: _onLoad,
      child: GroupedListView<Trip, dynamic>(
        shrinkWrap: true,
        sort: false,
        useStickyGroupSeparators: true,
        elements: _upcomingTripList,
        groupBy: (element) => element.date,
        groupSeparatorBuilder: (value) => Container(
          margin: const EdgeInsets.only(left: 21, right: 20),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        // controller: _scrollController,
        // ignore: missing_return
        itemBuilder: (context, element) {
          if (element.todayHasTrip != null) {
            if (element.todayHasTrip! > 0) {
              return Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
                decoration: BoxDecoration(
                    color: const Color(0xffffffdd),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    _routeNo(element.routeNo),
                    const SizedBox(height: 15),
                    _activeTripStartTime(dateToAlphaTime((element.plannedStart?.toLocal().add(Duration(minutes: element.adjustment))).toString())),
                    const SizedBox(height: 15),
                    _activeTripRoute('${element.departure} to ${element.destination}'),
                    const SizedBox(height: 20),
                    // TODO
                    _tripStartButton(element),
                  ],
                ),
              );
            } else {
              return Container(
                height: 116,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
                decoration: BoxDecoration(
                    color: const Color(0xffffffdd),
                    borderRadius: BorderRadius.circular(10)
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Today you don\'t have any trips.',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),
                ),
              );
            }
          }
          return Column(
            children: [
              TripCard(trip: element, ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _activeTripStartTime(String text) {
    return Container(
      margin: EdgeInsets.only(left: fitSize(30)),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.bold,
            fontSize: 18
        ),
      ),
    );
  }

  Widget _activeTripRoute(String text) {
    return Container(
      margin: EdgeInsets.only(left: fitSize(20)),
      child: Text(
        text,
        softWrap: true,
        style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Lexend',
            fontSize: 18
        ),
      ),
    );
  }

  Widget _routeNo(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      height: 24,
      width: 60,
      decoration: BoxDecoration(
        color: const Color(0xffe40947),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Lexend'
        ),
      ),
    );
  }

  Widget _tripStartButton(Trip trip) {
    int startPointRange = /*SystemParams.instance.get('start_point_range') ??*/ 100000;
    return GestureDetector(
      onTap: () async {
        if (ActiveTrip.instance.activeTrip?.id != trip.id) {
          await ActiveTrip.instance.assign(trip);
        }
/*        if (mounted) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TripActionPage(trip: trip)));
        }
        return;*/
        Position currentPos = await _getUserCurrentLocation();
        if (_checkDistance(currentPos.latitude, currentPos.longitude, trip.startLat ?? 0.0, trip.startLon ?? 0.0) < startPointRange) {
          Map<String, dynamic> params = <String, dynamic>{};
          params['id'] = trip.id;
          params['status'] = 3;
          params['startedAt'] = DateTime.now().toString();
          TripService.updateTrip(params);
          trip.startedAt = DateTime.now();
          if (mounted) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TripActionPage(trip: trip)));
          }
        } else {
          if (mounted) {
            Toast.toast(context,msg: AppLocalizations.of(context)?.haveNotArrivedDeparture ?? 'You have not arrived at departure point yet. ', position: ToastPostion.center);
          }
        }
      },
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            color: const Color(0xff008d41),
            borderRadius: BorderRadius.circular(10)
        ),
        alignment: Alignment.center,
        child: const Text(
          'Get Started',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 18
          ),
        ),
      ),
    );
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
    print('Distance is $d m');
    return d;
  }

  double _rad(double d) {
    return d * pi / 180.0;
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
}
