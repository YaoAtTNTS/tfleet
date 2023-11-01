

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:tfleet/model/driver/trip.dart';
import 'package:tfleet/service/driver/trip_service.dart';
import 'package:tfleet/utils/event.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/view/driver/component/trip_card.dart';
import 'package:tfleet/view/feedback/page_feedback.dart';

class MissedTripsPage extends StatefulWidget {
  const MissedTripsPage({Key? key, }) : super(key: key);

  @override
  State<MissedTripsPage> createState() => _MissedTripsPageState();
}

class _MissedTripsPageState extends State<MissedTripsPage> {

  bool loading = true;
  bool error = false;
  bool empty = false;
  bool replace = true;
  bool hasMore = true;
  bool firstRefresh = true;
  String errorMsg = '';

  final List<Trip> _missedTripList = [];

  late EasyRefreshController _easyRefreshController;

  Future _getTripList() async {

    Map<String, dynamic> params = <String, dynamic>{};
    if (Global.getRole() == 2) {
      params['driverId'] = Global.getUserId();
    } else {
      params['attendantId'] = Global.getUserId();
    }
    params['status'] = -2;
    params['desc'] = 1;
    String today = dateToAlphaMonth(DateTime.now().toString());
    var trips = await TripService.getTrips(params: params);
    for (Map<String, dynamic> tripJson in trips) {
      Trip trip = Trip.fromJson(tripJson);
      trip.date = dateToAlphaMonth(tripJson['plannedStart']);
      if (trip.date == today) {
        trip.date = 'Today, $today';
      }
      _missedTripList.add(trip);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _easyRefreshController = EasyRefreshController();

    event.on('MISSED', (start, end) {
      if (mounted) {
        setState(() {
          if (start != null && end != null) {
            for (Trip trip in _missedTripList) {
              if (trip.plannedStart != null && trip.plannedStart!.isAfter(start) && trip.plannedStart!.isBefore(end)) {
                trip.visible = true;
              } else {
                trip.visible = false;
              }
            }
          } else if (start != null && end == null) {
            for (Trip trip in _missedTripList) {
              if (trip.plannedStart != null && trip.plannedStart!.isAfter(start)) {
                trip.visible = true;
              } else {
                trip.visible = false;
              }
            }
          } else if (start == null && end != null) {
            for (Trip trip in _missedTripList) {
              if (trip.plannedStart != null && trip.plannedStart!.isBefore(end)) {
                trip.visible = true;
              } else {
                trip.visible = false;
              }
            }
          } else if (start == null && end == null) {
            for (Trip trip in _missedTripList) {
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
    _missedTripList.clear();
    await _getTripList();
    if (_missedTripList.isEmpty) {
      setState(() => empty = true);
    }
    firstRefresh = false;
    loading = false;
    _easyRefreshController.resetLoadState();
  }

  Future _onLoad() async {
   // if (hasMore) {
   // }
    //_easyRefreshController.finishLoad(noMore: !hasMore);
  }

  void _onDelete(Trip trip) {
    setState(() {
      _missedTripList.remove(trip);
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
        empty: _missedTripList.isEmpty,
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
        elements: _missedTripList,
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
}
