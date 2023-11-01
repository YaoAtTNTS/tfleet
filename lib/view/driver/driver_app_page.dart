

import 'package:flutter/material.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'package:tfleet/locale/app_localizations.dart';
import 'package:tfleet/main.dart';
import 'package:tfleet/utils/active_trip.dart';
import 'package:tfleet/utils/event.dart';
import 'package:tfleet/utils/format_utils.dart';
import 'package:tfleet/utils/global.dart';
import 'package:tfleet/utils/system_params.dart';
import 'package:tfleet/view/common/component/dot_notice_badge.dart';
import 'package:tfleet/view/common/component/number_notice_badge.dart';
import 'package:tfleet/view/common/notification_page.dart';
import 'package:tfleet/view/driver/app/trip_action_page.dart';
import 'package:tfleet/view/driver/app/trip_list_page.dart';

import 'app/my_page.dart';

const List<Map> _bottomBarList = [
  {
    'icon': 'trips.png',
    'label': 'Trips',
  },
  {
    'icon': 'notification.png',
    'label': 'Notification',
  },
  {
    'icon': 'me.png',
    'label': 'Me',
  }
];

class DriverAppPage extends StatefulWidget {
  const DriverAppPage({Key? key}) : super(key: key);

  @override
  _DriverAppPageState createState() => _DriverAppPageState();
}

class _DriverAppPageState extends State<DriverAppPage> {

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, ActiveTrip.instance.init);
    Future.delayed(Duration.zero, SystemParams.instance.init);

    event.on('DRIVER_MESS', (arg0, arg1) {
      setState(() {
        Global.updateUnread(1);
        _currentIndex = 1;
      });
    });

    // event.on('DRIVER_READ', (arg0, arg1) {
    //   setState(() {});
    // });

    if (Global.isOpenedByNotification) {
      Global.isOpenedByNotification = false;
      Global.updateUnread(1);
      setState(() {
        _currentIndex = 1;
      });
    }
  }

  final List<IndexedStackChild> _pageList = [
    IndexedStackChild(child: const TripListPage()),
    // TestPage(),
    IndexedStackChild(child: const NotificationPage()),
    IndexedStackChild(child: const MyPage())
  ];

  void _onTabbarClick(int index) {
    if (mounted) {
      setState(() {
            _currentIndex = index;
          });
    }
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
      case 'Trips':
        return AppLocalizations.of(context)?.trips ?? text;
      case 'Action':
        return AppLocalizations.of(context)?.action ?? text;
      case 'Notification':
        return AppLocalizations.of(context)?.notification ?? text;
      case 'Me':
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

