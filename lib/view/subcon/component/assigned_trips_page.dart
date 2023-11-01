

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/driver/trip.dart';
import 'package:tfleet/service/driver/trip_service.dart';
import 'package:tfleet/utils/event.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/view/feedback/page_feedback.dart';
import 'package:tfleet/view/subcon/component/assigned_trip_card.dart';

class AssignedTripsPage extends StatefulWidget {
  const AssignedTripsPage({Key? key}) : super(key: key);

  @override
  State<AssignedTripsPage> createState() => _AssignedTripsPageState();
}

class _AssignedTripsPageState extends State<AssignedTripsPage> {

  bool loading = true;
  bool error = false;
  bool replace = true;
  bool hasMore = true;
  String errorMsg = '';

  final List<Trip> _assignedTripList = [];

  late EasyRefreshController _easyRefreshController;

  Future _getTripList() async {

    Map<String, dynamic> params = <String, dynamic>{};
    params['ownerId'] = Global.getUserId();
    params['statuses'] = [1,2,3,4].toString();
    String today = dateToAlphaMonth(DateTime.now().toString());
    var trips = await TripService.getTrips(params: params);
    for (Map<String, dynamic> tripJson in trips) {
      Trip trip = Trip.fromJson(tripJson);
      trip.date = dateToAlphaMonth(tripJson['plannedStart']);
      if (trip.date == today) {
        trip.date = 'Today, $today';
      }
      _assignedTripList.add(trip);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
    // _getTripList();
    event.on('ASSIGNED', (start, end) {
      if (mounted) {
        setState(() {
          if (start != null && end != null) {
            for (Trip trip in _assignedTripList) {
              if (trip.plannedStart != null && trip.plannedStart!.isAfter(start) && trip.plannedStart!.isBefore(end)) {
                trip.visible = true;
              } else {
                trip.visible = false;
              }
            }
          } else if (start != null && end == null) {
            for (Trip trip in _assignedTripList) {
              if (trip.plannedStart != null && trip.plannedStart!.isAfter(start)) {
                trip.visible = true;
              } else {
                trip.visible = false;
              }
            }
          } else if (start == null && end != null) {
            for (Trip trip in _assignedTripList) {
              if (trip.plannedStart != null && trip.plannedStart!.isBefore(end)) {
                trip.visible = true;
              } else {
                trip.visible = false;
              }
            }
          } else if (start == null && end == null) {
            for (Trip trip in _assignedTripList) {
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
    _assignedTripList.clear();
    await _getTripList();
    if (error) {
      setState(() => error = false);
    }
    _easyRefreshController.resetLoadState();
  }

  Future _onLoad() async {
   // if (hasMore) {
   // }
    //_easyRefreshController.finishLoad(noMore: !hasMore);
  }


  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      firstRefresh: true,
      firstRefreshWidget: PageFeedBack(firstRefresh: true).build(),
      emptyWidget: PageFeedBack(
        loading: loading,
        error: error,
        empty: _assignedTripList.isEmpty,
        errorMsg: errorMsg,
        onErrorTap: () => {} /*_easyRefreshController.callRefresh()*/,
        onEmptyTap: () => {} /*_easyRefreshController.callRefresh()*/,
      ).build(),
      footer: ClassicalFooter(),
      controller: _easyRefreshController,
      enableControlFinishRefresh: false,
      enableControlFinishLoad: false,
      onRefresh: _onRefresh,
      onLoad: _onLoad,
      child: GroupedListView<Trip, dynamic>(
        shrinkWrap: true,
        sort: false,
        useStickyGroupSeparators: true,
        elements: _assignedTripList,
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
              AssignedTripCard(trip: element, ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
