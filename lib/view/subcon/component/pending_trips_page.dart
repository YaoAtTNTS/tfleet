

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/driver/trip.dart';
import 'package:tfleet/service/driver/trip_service.dart';
import 'package:tfleet/utils/event.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/utils/t_color.dart';
import 'package:tfleet/view/driver/component/status_filter.dart';
import 'package:tfleet/view/feedback/page_feedback.dart';
import 'package:tfleet/view/subcon/component/pending_trip_card.dart';

class PendingTripsPage extends StatefulWidget {
  const PendingTripsPage({Key? key}) : super(key: key);

  @override
  State<PendingTripsPage> createState() => _PendingTripsPageState();
}

class _PendingTripsPageState extends State<PendingTripsPage> {


  final List<Trip> _tripList = [];

  late EasyRefreshController _easyRefreshController;

  final Map<String, bool> _checkboxSelectedList = {};

  bool loading = true;
  bool error = false;
  bool replace = true;
  bool hasMore = true;
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
    // _getTripList();
    event.on('PENDING', (start, end) {
      if (mounted) {
        setState(() {
          if (start != null && end != null) {
            for (Trip trip in _tripList) {
              if (trip.plannedStart != null && trip.plannedStart!.isAfter(start) && trip.plannedStart!.isBefore(end)) {
                trip.visible = true;
              } else {
                trip.visible = false;
              }
            }
          } else if (start != null && end == null) {
            for (Trip trip in _tripList) {
              if (trip.plannedStart != null && trip.plannedStart!.isAfter(start)) {
                trip.visible = true;
              } else {
                trip.visible = false;
              }
            }
          } else if (start == null && end != null) {
            for (Trip trip in _tripList) {
              if (trip.plannedStart != null && trip.plannedStart!.isBefore(end)) {
                trip.visible = true;
              } else {
                trip.visible = false;
              }
            }
          } else if (start == null && end == null) {
            for (Trip trip in _tripList) {
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
    _tripList.clear();
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

  Future _getTripList() async {

    Map<String, dynamic> params = <String, dynamic> {};
    params['ownerId'] = Global.getUserId();
    params['status'] = 0;
    var trips = await TripService.getTrips(params: params);
    String today = dateToAlphaMonth(DateTime.now().toString());
    for (Map<String, dynamic> tripJson in trips) {
      Trip trip = Trip.fromJson(tripJson);
      trip.date = dateToAlphaMonth(tripJson['plannedStart']);
      if (trip.date == today) {
        trip.date = 'Today, $today';
      }
      _tripList.add(trip);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      firstRefresh: true,
      firstRefreshWidget: PageFeedBack(firstRefresh: true).build(),
      emptyWidget: PageFeedBack(
        loading: loading,
        error: error,
        empty: _tripList.isEmpty,
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
        elements: _tripList,
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
              PendingTripCard(trip: element, ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  // Future<int?> _showBottomModal(context) async {
  //   var size = MediaQuery.of(context).size;
  //   return showModalBottomSheet(
  //     backgroundColor: Colors.transparent,
  //     isDismissible: true,
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         width: size.width,
  //         height: size.height * 0.7,
  //         decoration: const BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(30),
  //             topRight: Radius.circular(30),
  //           ),
  //         ),
  //         child: StatusFilter(checkboxSelectedList: _checkboxSelectedList, onFiltered: _onFiltered,),
  //       );
  //     },
  //   );
  // }
}
