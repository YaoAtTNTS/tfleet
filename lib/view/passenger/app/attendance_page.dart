

import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/model/passenger/address.dart';
import 'package:tfleet/model/passenger/attendance.dart';
import 'package:tfleet/model/passenger/child.dart';
import 'package:tfleet/service/passenger/address_service.dart';
import 'package:tfleet/service/passenger/attendance_service.dart';
import 'package:tfleet/service/passenger/child_service.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/view/feedback/page_feedback.dart';
import 'package:tfleet/view/passenger/component/attendance_card.dart';
import 'package:weekly_date_picker/weekly_date_picker.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage>
    with AutomaticKeepAliveClientMixin {

  final List<Attendance> _attendanceList = [];

  DateTime? startDate;
  DateTime? endDate;

  DateTime _selectedDay = DateTime.now();

  bool loading = true;
  bool error = false;
  bool replace = true;
  bool hasMore = true;
  String errorMsg = '';

  late EasyRefreshController _easyRefreshController;

  @override
  void initState() {
    super.initState();
    _easyRefreshController = EasyRefreshController();
    _getAttendanceList();
    if (_selectedDay.weekday == 6) {
      _selectedDay = _selectedDay.add(const Duration(days: 2));
    } else if (_selectedDay.weekday == 7) {
      _selectedDay = _selectedDay.add(const Duration(days: 1));
    }
    Future.delayed(const Duration(seconds: 1), _getAddress);
    Future.delayed(const Duration(seconds: 2), _getChildrenList);
  }

  @override
  void dispose() {
    navigatorKey.currentState?.dispose();
    _easyRefreshController.dispose();
    super.dispose();
  }

  Future _onRefresh() async {
    await _getAttendanceList();
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

  Future _getAttendanceList() async {
    _attendanceList.clear();
    List<dynamic> attendances = await AttendanceService.getAttendances(Global.getUserId()!, _selectedDay.toIso8601String().substring(0,10));
    for (Map<String, dynamic> attendanceJson in attendances) {
      Attendance attendance = Attendance.fromJson(attendanceJson);
      _attendanceList.add(attendance);
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future _getAddress() async {
    var addresses = await AddressService.getAddresses(Global.getUserId()!);
    Address? address;
    for (Map<String, dynamic> addressJson in addresses) {
      if (addressJson['status'] == 0) {
        address = Address.fromJson(addressJson);
      } else if (addressJson['status'] == 1) {
        Global.hasPendingAddress = true;
        Global.pendingAddressCreatedAt = (addressJson['createdAt'] != null ? DateTime.parse(addressJson['createdAt']) : null);
      }
    }
    if (address != null) {
      Global.saveAddress(address);
    }
  }

  Future _getChildrenList() async {
    if (Global.yourChildren.isEmpty) {
      var children = await ChildService.getChildren(Global.getUserId()!);
      for(Map<String, dynamic> childJson in children) {
        Global.yourChildren.add(Child.fromJson(childJson));
      }
      Set<int> ids = {};
      Global.yourChildren.retainWhere((element) {
        if (ids.contains(element.id)) {
          return false;
        } {
          ids.add(element.id!);
          return true;
        }
      });
    }
  }

  Widget _weeklyCalendarView() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _selectedDay = _selectedDay.subtract(const Duration(days: 1));
              _getAttendanceList();
            });
          },
          icon: const Icon(
              Icons.chevron_left,
          ),
        ),
        Expanded(
          child: WeeklyDatePicker(
            selectedDay: _selectedDay, // DateTime
            changeDay: (v) => null,
            // changeDay: (value) => setState(() {
            //   if (!value.isAfter(DateTime.now())) {
            //     _selectedDay = value;
            //   }
            //   _getAttendanceList();
            // }),
            enableWeeknumberText: false,
            selectedBackgroundColor: Colors.grey,
            // daysInWeek: 5,
            // weekdays: const ["Mon", "Tue", "Wed", "Thu", "Fri"],
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              if (!_selectedDay.isAfter(DateTime.now())) {
                _selectedDay = _selectedDay.add(const Duration(days: 1));
                _getAttendanceList();
              }
            });
          },
          icon: const Icon(
            Icons.chevron_right,
          ),
        ),
      ],
    );
  }

  Widget _attendanceListView() {
    return EasyRefresh(
      firstRefresh: false,
      firstRefreshWidget: const PageFeedBack(firstRefresh: false).build(),
      emptyWidget: PageFeedBack(
        // loading: loading,
        error: error,
        empty: _attendanceList.isEmpty,
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
      child: GroupedListView<Attendance, dynamic>(
        shrinkWrap: true,
        useStickyGroupSeparators: true,
        elements: _attendanceList,
        groupBy: (element) => element.childName,
        groupSeparatorBuilder: (value) => Container(
          margin: const EdgeInsets.all(20),
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
        itemBuilder: (context, element) {
          return Column(
            children: [
              AttendanceCard(attendance: element, ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    DateTime now = DateTime.now();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      key: navigatorKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: width,
                height: width * 0.28,
                decoration: BoxDecoration(
                    color: const Color(0xffe40947),
                    borderRadius: BorderRadius.circular(18)
                ),
              ),
              Positioned(
                left: 40,
                top: 34,
                child: IconButton(
                  onPressed: () {
                    // Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.menu,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 48,
                child: Container(
                    width: width,
                    alignment: Alignment.topCenter,
                    child: Text(
                      now.hour < 12 ? 'Good Morning!' : (now.hour < 18 ? 'Good Afternoon!' : 'Good Evening!'),
                      style: const TextStyle(
                          fontSize: 24,
                          fontFamily: 'Lexend Deca',
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                ),
              ),
              Positioned(
                top: width*0.22,
                  left: 7,
                  child: Container(
                    height: 2,
                    width: width - 10,
                    color: Colors.white,
                  )
              ),
              Positioned(
                  bottom: 4,
                  left: 10,
                  width: width - 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Welcome, ${Global.username()}',
                        style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Lexend Deca',
                            color: Colors.white
                        ),
                      ),
                      Text(
                        '${dateToAlphaMonth(now.toString())} ${now.year}',
                        style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Lexend Deca',
                            color: Colors.white
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
          const SizedBox(height: 5,),
          _weeklyCalendarView(),
          const SizedBox(height: 5,),
          Expanded(child: _attendanceListView()),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
