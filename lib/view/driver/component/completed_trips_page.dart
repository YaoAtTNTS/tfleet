

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:tfleet/model/driver/trip.dart';
import 'package:tfleet/service/driver/trip_service.dart';
import 'package:tfleet/utils/event.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/view/driver/app/trip_summary_page.dart';
import 'package:tfleet/view/driver/component/trip_card.dart';
import 'package:tfleet/view/feedback/page_feedback.dart';

class CompletedTripsPage extends StatefulWidget {
  const CompletedTripsPage({Key? key, }) : super(key: key);

  @override
  State<CompletedTripsPage> createState() => _CompletedTripsPageState();
}

class _CompletedTripsPageState extends State<CompletedTripsPage> {

  bool loading = true;
  bool error = false;
  bool empty = false;
  bool replace = true;
  bool hasMore = true;
  bool firstRefresh = true;
  String errorMsg = '';

  final List<Trip> _completedTripList = [];

  late EasyRefreshController _easyRefreshController;

  Future _getTripList() async {

    Map<String, dynamic> params = <String, dynamic>{};
    if (Global.getRole() == 2) {
      params['driverId'] = Global.getUserId();
    } else {
      params['attendantId'] = Global.getUserId();
    }
    params['status'] = 4;
    String today = dateToAlphaMonth(DateTime.now().toString());
    var trips = await TripService.getTrips(params: params);
    for (Map<String, dynamic> tripJson in trips) {
      Trip trip = Trip.fromJson(tripJson);
      trip.date = dateToAlphaMonth(tripJson['startedAt']);
      if (trip.date == today) {
        trip.date = 'Today, $today';
      }
      _completedTripList.add(trip);
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

    event.on('COMPLETED', (start, end) {
      if (mounted) {
        setState(() {
          if (start != null && end != null) {
            for (Trip trip in _completedTripList) {
              if (trip.plannedStart != null && trip.plannedStart!.isAfter(start) && trip.plannedStart!.isBefore(end)) {
                trip.visible = true;
              } else {
                trip.visible = false;
              }
            }
          } else if (start != null && end == null) {
            for (Trip trip in _completedTripList) {
              if (trip.plannedStart != null && trip.plannedStart!.isAfter(start)) {
                trip.visible = true;
              } else {
                trip.visible = false;
              }
            }
          } else if (start == null && end != null) {
            for (Trip trip in _completedTripList) {
              if (trip.plannedStart != null && trip.plannedStart!.isBefore(end)) {
                trip.visible = true;
              } else {
                trip.visible = false;
              }
            }
          } else if (start == null && end == null) {
            for (Trip trip in _completedTripList) {
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
    _completedTripList.clear();
    await _getTripList();
    if (_completedTripList.isEmpty) {
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
      _completedTripList.remove(trip);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      firstRefresh: true,
      firstRefreshWidget: PageFeedBack(firstRefresh: firstRefresh, ).build(),
      emptyWidget: PageFeedBack(
        loading: loading,
        error: error,
        empty: empty,
        errorMsg: errorMsg,
        onErrorTap: () =>  _easyRefreshController.callRefresh(),
        onEmptyTap: () =>  _easyRefreshController.callRefresh(),
        emptyMsg: 'No completed trips.'
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
        elements: _completedTripList,
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
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => TripSummaryPage(trip: element)));
                },
                  child: TripCard(trip: element, ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
