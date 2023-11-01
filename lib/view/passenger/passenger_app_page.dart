

import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/utils/event.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/view/common/component/dot_notice_badge.dart';
import 'package:tfleet/view/common/component/number_notice_badge.dart';
import 'package:tfleet/view/common/notification_page.dart';
import 'package:tfleet/view/passenger/app/attendance_page.dart';
import 'package:tfleet/view/passenger/app/children_page.dart';
import 'package:tfleet/view/passenger/app/my_page.dart';

const List<Map> _bottomBarList = [
  {
    'icon': 'attendance.png',
    'label': 'Attendance',
  },
  {
    'icon': 'message.png',
    'label': 'Notification',
  },
  {
    'icon': 'me.png',
    'label': 'My',
  }
];

class PassengerAppPage extends StatefulWidget {
  const PassengerAppPage({Key? key}) : super(key: key);

  @override
  _PassengerAppPageState createState() => _PassengerAppPageState();
}

class _PassengerAppPageState extends State<PassengerAppPage> {

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    event.on('PASS_MESS', (arg0, arg1) {
      if (mounted) {
        setState(() {
                Global.updateUnread(1);
                _currentIndex = 1;
              });
      }
    });
    event.on('PASS_READ', (arg0, arg1) {
      if (mounted) {
        setState(() {});
      }
    });
    if (Global.isOpenedByNotification) {
      Global.isOpenedByNotification = false;
      // Global.updateUnread(1);
      setState(() {
        _currentIndex = 1;
      });
    }
  }

  final List<IndexedStackChild> _pageList = [
    IndexedStackChild(child: const AttendancePage()),
    IndexedStackChild(child: const NotificationPage()),
    IndexedStackChild(child: const MyPage())
  ];

  void _onTabbarClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<BottomNavigationBarItem> _bottomNavigationBarItems() {
    return _bottomBarList.map((item) {
      if (item['label'] == 'Notification' && Global.unread() > 0) {
        return BottomNavigationBarItem(
          icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  'assets/image/icon/' + item['icon'],
                  width: fitSize(60),
                  height: fitSize(60),
                  color: Colors.grey,
                ),
                Positioned(
                  top: -fitSize(15),
                  right: -fitSize(15),
                  child: NumberNoticeBadge(count: Global.unread()),
                )
              ]
          ),
          activeIcon: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                'assets/image/icon/' + item['icon'],
                width: fitSize(60),
                height: fitSize(60),
                color: const Color(0xffe40947),
              ),
              Positioned(
                top: -fitSize(15),
                right: -fitSize(15),
                child: NumberNoticeBadge(count: Global.unread()),
              )
            ],
          ),
          label: getLocalizedBottomBarText(item['label']),
          tooltip: '',
        );
      }
      return BottomNavigationBarItem(
        icon: Image.asset(
          'assets/image/icon/' + item['icon'],
          width: fitSize(60),
          height: fitSize(60),
          color: Colors.grey,
        ),
        activeIcon: Image.asset(
          'assets/image/icon/' + item['icon'],
          width: fitSize(60),
          height: fitSize(60),
          color: const Color(0xffe40947),
        ),
        label: getLocalizedBottomBarText(item['label']),
        tooltip: '',
      );
    }).toList();
  }

  String getLocalizedBottomBarText(String text) {
    switch (text) {
      case 'Attendance':
        return AppLocalizations.of(context)?.attendance ?? text;
      case 'Action':
        return AppLocalizations.of(context)?.action ?? text;
      case 'Notification':
        return AppLocalizations.of(context)?.notification ?? text;
      case 'My':
        return AppLocalizations.of(context)?.my ?? text;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ProsteIndexedStack(
        index: _currentIndex,
        children: _pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        // fixedColor: Colors.grey,
        items: _bottomNavigationBarItems(),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onTabbarClick,
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color(0xffe40947),
      ),
    );
  }
}

