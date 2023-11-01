

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/model/driver/trip.dart';
import 'package:tfleet/service/driver/trip_service.dart';
import 'package:tfleet/utils/event.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/view/driver/component/completed_trips_page.dart';
import 'package:tfleet/view/driver/component/missed_trips_page.dart';
import 'package:tfleet/view/driver/component/status_filter.dart';
import 'package:tfleet/view/driver/component/trip_card.dart';
import 'package:tfleet/view/driver/component/upcoming_trips_page.dart';
import 'package:tfleet/view/feedback/page_feedback.dart';

class TripListPage extends StatefulWidget {
  const TripListPage({Key? key}) : super(key: key);

  @override
  State<TripListPage> createState() => _TripListPageState();
}

class _TripListPageState extends State<TripListPage> with TickerProviderStateMixin {

  final List<Widget> _pageList = [
    const UpcomingTripsPage(),
    const CompletedTripsPage(),
    const MissedTripsPage()
  ];

  // DateTime? startDate;
  // DateTime? endDate;

  final List<Widget> _tabs = [
    Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onDoubleTap: () {
          event.emit('UPCOMING', null, null);
        },
        child: const Text(
            'UPCOMING',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Raleway'
          ),
        ),
      ),
    ),
    Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onDoubleTap: () {
          event.emit('COMPLETED', null, null);
        },
        child: const Text(
          'COMPLETED',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Raleway'
          ),
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onDoubleTap: () {
          event.emit('MISSED', null, null);
        },
        child: const Text(
          'MISSED',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Raleway'
          ),
        ),
      ),
    ),
  ];

  int _currentIndex = 0;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
            AppLocalizations.of(context)?.trips ??'My Trips',
          style: const TextStyle(
            color: Color(0xff030303),
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Raleway'
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: fitSize(25)),
            child: IconButton(
              icon: const Icon(
                  Icons.calendar_month,
                color: Color(0xffe40947),
              ),
              onPressed: () {
                // _showBottomModal(context);
                showConfirmDialog(context);
              },
            ),
          )
        ],
        bottom: TabBar(
          tabs: _tabs,
          isScrollable: true,
          controller: _tabController,
          labelColor: const Color(0xffe40947),
          indicatorColor: const Color(0xffe40947),
          unselectedLabelColor: const Color(0xffa4a7ac),
          onTap: (index) {
            if (mounted) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: _pageList,
      ),
    );
  }

  // void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  //   startDate = args.value.startDate;
  //   endDate = args.value.endDate;
  //   if (startDate != null && endDate!=null) {
  //     endDate = endDate!.add(const Duration(days: 1));
  //   }
  // }

  Future<dynamic> showConfirmDialog(BuildContext buildContext) async {
    return showDialog<dynamic>(
      context: buildContext,
      builder: (context) {
        return Column(
          children: [
            const SizedBox(height: 100,),
            Expanded(
              child: SfDateRangePicker(
                // onSelectionChanged: _onSelectionChanged,
                backgroundColor: Colors.white,
                showActionButtons: true,
                onCancel: () {
                  Navigator.of(context).pop();
                },
                onSubmit: (v) {
                  Navigator.of(context).pop();
                  if (v is PickerDateRange) {
                    if (v.startDate != null && v.endDate!=null) {
                      // endDate = endDate!.add(const Duration(days: 1));
                      switch(_currentIndex) {
                        case 0:
                          event.emit('UPCOMING', v.startDate, v.endDate!.add(const Duration(days: 1)));
                          break;
                        case 1:
                          event.emit('COMPLETED', v.startDate, v.endDate!.add(const Duration(days: 1)));
                          break;
                        case 2:
                          event.emit('MISSED', v.startDate, v.endDate!.add(const Duration(days: 1)));
                          break;
                        default:
                          break;
                      }
                    }
                  }
                },
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 4)),
                    DateTime.now().add(const Duration(days: 3))),
              ),
            ),
            const SizedBox(height: 400,)
          ]
        );
      },
    );
  }
}
