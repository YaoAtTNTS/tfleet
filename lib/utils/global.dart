

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tfleet/model/driver/student_name_card_data.dart';
import 'package:tfleet/model/geo_coordinates.dart';
import 'package:tfleet/model/passenger/address.dart';
import 'package:tfleet/model/passenger/child.dart';
import 'package:tfleet/model/notification.dart' as my;


class Global {

  static late SharedPreferences _prefs;
  static String? _clientID;
  static String? _username;
  static String? _email;
  static int? _userId; // unique, all addresses and attendance records bind to this id
  static String? _url;
  static String? _password;
  static int? _role;
  static int? loginStatus;
  static String? fcmToken;
  static Address? _address;
  static bool hasPendingAddress = false;
  static DateTime? pendingAddressCreatedAt;

  static List<Child> studentsAtCurrentPickupPoint = [];

  static Map<int, int> studentsAttendanceStatus = {};

  static List<Child> yourChildren = [];

  static List<GeoCoordinates> remainingPups = [];
  static List<String> _passedPups = [];

  static Set<int> absentIds = {};
  static Set<int> presentIds = {};

  static String? currentVehicleNo;

  static bool isOpenedByNotification = false;
  static int? _unread;

  static int? _attendanceOff;

  static my.Notification? _welcomeMsg;

  // static final List<Address> _addresses = [];

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();

    var profile = _prefs.getString('clientID');
    if (profile != null) {
      _clientID = profile;
    }
    if (_prefs.containsKey('login_status')) {
      loginStatus = _prefs.getInt('login_status')!;
    }
    if (_prefs.containsKey('fcmToken')) {
      fcmToken = _prefs.getString('fcmToken')!;
    }
    if (_prefs.containsKey('role')) {
      _role = _prefs.getInt('role');
    }
    if (_prefs.containsKey('userId')) {
      _userId = _prefs.getInt('userId');
    }
    if (_prefs.containsKey('userName')) {
      _username = _prefs.getString('userName');
    }
    if (_prefs.containsKey('password')) {
      _password = _prefs.getString('password');
    }
    if (_prefs.containsKey('url')) {
      _url = _prefs.getString('url');
    }
    if (_prefs.containsKey('attendance_off')) {
      _attendanceOff = _prefs.getInt('attendance_off');
    }
    if (_prefs.containsKey('_unread')) {
      _unread = _prefs.getInt('_unread');
    }
  }

  static clear() {
    _prefs.remove("clientID");
    _prefs.remove('login_status');
    loginStatus = 0;
    _userId = null;
    _username = null;
    _password = null;
    _email = null;
    fcmToken = null;
    _url = null;
    _address = null;
    _attendanceOff = null;
    currentVehicleNo = null;
    _unread = null;
    studentsAtCurrentPickupPoint.clear();
    remainingPups.clear();
    yourChildren.clear();
    _prefs.clear();
  }

  static saveClientID(String id) {
    _prefs.setString("clientID", id);
    _clientID = id;
  }
  
  static String? clientID() {
    if (_clientID == null) {
      if (_prefs.containsKey('clientID')) {
        _clientID = _prefs.getString('clientID');
      }
    }
    return _clientID;
  }

  static saveUrl(String? url) {
    if (url != null) {
      _prefs.setString("url", url);
      _url = url;
    }
  }

  static String? url() {
    if (_url == null) {
      if (_prefs.containsKey('url')) {
        _url = _prefs.getString('url');
      }
    }
    return _url;
  }

  static saveUsername(String name) {
    _prefs.setString("userName", name);
    _username = name;
  }

  static String? username() {
    if (_username == null) {
      if (_prefs.containsKey('userName')) {
        _username = _prefs.getString('userName');
      }
    }
    return _username;
  }

  static saveEmail(String email) {
    _prefs.setString("email", email);
    _email = email;
  }

  static String? email() {
    if (_email == null) {
      if (_prefs.containsKey('email')) {
        _email = _prefs.getString('email');
      }
    }
    return _email;
  }

  static savePassword(String pass) {
    _prefs.setString("password", pass);
    _password = pass;
  }

  static String? password() {
    if (_password == null) {
      if (_prefs.containsKey('password')) {
        _password = _prefs.getString('password');
      }
    }
    return _password;
  }
  
  static saveUserId(int id) {
    // _userId = 0;
    _prefs.setInt('userId', id);
  }

  static int? getUserId() {
    if (_userId != null) {
      return _userId;
    } else if (_prefs.containsKey('userId')) {
      return _prefs.getInt('userId');
    } else {
      return null;
    }
  }

  static int getRole () {

    if (_role == null) {
      if (_prefs.containsKey('role')) {
        _role = _prefs.getInt('role');
      }
    }
    return _role ?? 0;
  }

  static saveRole (int r) {
    _role = r;
    _prefs.setInt('role', r);
  }

  static saveLoginStatus() {
    _prefs.setInt('login_status', 1);
    loginStatus = 1;
  }

  static saveFcmToken(String token) {
    _prefs.setString('fcmToken', token);
    fcmToken = token;
  }

  static setAttendanceOff (int off) {
    _attendanceOff = off;
    _prefs.setInt('attendance_off', off);
  }

  static attendanceOff() {
    if (_attendanceOff == null) {
      if (_prefs.containsKey('attendance_off')) {
        _attendanceOff = _prefs.getInt('attendance_off');
      }
    }
    return _attendanceOff;
  }

  // static saveAddress(List<Address> list) {
  //   _addresses.addAll(list);
  // }
  //
  // static List<Address> getAddresses() {
  //   return _addresses;
  // }
  //
  // static removeAddresses() {
  //   _addresses.clear();
  // }

  static saveAddress (Address address) {
    _address = null;
    _address = address;
  }

  static Address? getAddress () {
    return _address;
  }

  static updateAddress (Address address) {
    _address?.address = address.address;
    _address?.name= address.name;
    _address?.unitNo= address.unitNo;
  }

/*  static updateStudentAbsence (int id, bool absence) {
    if (studentsAtCurrentPickupPoint.isNotEmpty) {
      int length = studentsAtCurrentPickupPoint.length;
      for (int i = 0; i < length; i++) {
        if (studentsAtCurrentPickupPoint[i].id == id) {
          *//*Child data = *//*studentsAtCurrentPickupPoint[i].isAbsent = absence;
          // data.isAbsent = absence;
          // studentsAtCurrentPickupPoint[i] = data;
        }
      }
    }
  }*/

  static updateUnread(int count) {
    _unread = (_unread??0) + count;
    _prefs.setInt('_unread', _unread!);
  }

  static setUnread(int count) {
    _unread = count;
    _prefs.setInt('_unread', _unread!);
  }

  static int unread() {
    if (_unread == null) {
      if (_prefs.containsKey('_unread')) {
        _unread = _prefs.getInt('_unread');
      }
    }
    return _unread ?? 0;
  }

  static my.Notification? welcomeMsg() {
    if (_welcomeMsg == null) {
      if (_prefs.containsKey('welcome_title')) {
        _welcomeMsg = my.Notification(
            id: 0,
            notificationId: '',
            userId: 0,
            title: _prefs.getString('welcome_title') ?? '',
            content: _prefs.getString('welcome_content') ?? '',
            time: _prefs.containsKey('welcome_time') ? DateTime.parse(_prefs.getString('welcome_time')!) : null,
            status: _prefs.getInt('welcome_status') ?? 1
        );
      }
    }
    return _welcomeMsg;
  }

  static saveWelcomeMsg(String title, String content, DateTime time, int status) {
    _welcomeMsg = my.Notification(
        id: 0,
        notificationId: '',
        userId: 0,
        title: title,
        content: content,
        time: time,
        status: status
    );
    _prefs.setString('welcome_title', title);
    _prefs.setString('welcome_content', content);
    _prefs.setString('welcome_time', time.toString());
    _prefs.setInt('welcome_status', status);
  }

  static readWelcomeMsg() {
    _welcomeMsg?.status = 2;
    _prefs.setInt('welcome_status', 2);
  }

  static List<String> restorePassedPups (int tripId) {
    if (_prefs.containsKey('trip_status')) {
      String? tripStatus = _prefs.getString('trip_status');
      if (tripStatus != null) {
        List<String> splits = tripStatus.split(';');
        if (int.parse(splits[0]) == tripId) {
          _passedPups = splits;
        }
      }
    }
    return _passedPups;
  }

  static savePassedPups (int pupId) {
    _passedPups.add(pupId.toString());
    _prefs.setString('trip_status', _passedPups.join(';'));
  }

  static String? getPassedPups () {
    if (_prefs.containsKey('trip_status')) {
      return _prefs.getString('trip_status');
    }
    return null;
  }

  static int getStudentAttendanceStatus(int student) {
    if (studentsAttendanceStatus.containsKey(student)) {
      return studentsAttendanceStatus[student]!;
    }
    return 0;
  }

}