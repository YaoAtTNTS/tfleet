
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tfleet/utils/constants.dart';

String formatCharCount(int count) {
  if (count == null || count < 0 || count.isNaN) {
    return '0';
  }
  String strCount = count.toString();
  if (strCount.length >= 5) {
    // 如：123456 => 12
    String prefix = strCount.substring(0, strCount.length - 4);
    if (strCount.length == 5) {
      prefix += '.' + strCount[1];
    }
    if (strCount.length == 6) {
      prefix += '.' + strCount[2];
    }
    return prefix + 'w';
  }
  return strCount;
}

/// 秒数转 时:分:秒
String secondsToTime(int seconds) {
  if (seconds == null || seconds <= 0 || seconds.isNaN) {
    return '00:00';
  }
  // 时分数
  int hours = 0;
  // 分钟数
  int minutes = 0;
  // 除整数分钟外剩余的秒数
  int remainingSeconds = 0;

  hours = (seconds / 60 / 60).floor();
  minutes = (seconds / 60 % 60).floor();
  remainingSeconds = seconds % 60;

  if (hours == 0) {
    return '${formatNumber(minutes)}:${formatNumber(remainingSeconds)}';
  }
  // 返回 时:分:秒
  return '${formatNumber(hours)}:${formatNumber(minutes)}:${formatNumber(remainingSeconds)}';
}

final DateFormat isoDateFormat = DateFormat(
  'yyyy-MM-dd HH:mm:ss',
  'en_US',
);

bool compareDateString(String dateString1, String dateString2) {
  late DateTime date1;
  late DateTime date2;
  date1 = isoDateFormat.parseStrict(dateString1);
  date2 = isoDateFormat.parseStrict(dateString2);

  return date1.millisecondsSinceEpoch > date2.millisecondsSinceEpoch;
}

String formatDateString(String date) {
  String newDate = date.substring(0,4) + '-' +
      date.substring(4,6) + '-' +
      date.substring(6, );
  return newDate.replaceAll('T', ' ');
}

DateTime stringToDate(String time) {
  String s = time.replaceRange(10, time.length, ' 00:00:00');
  return isoDateFormat.parseStrict(s);
}

/// 个数补零
String formatNumber(int count) {
  String strCount = count.toString();
  return strCount.length > 1 ? strCount : '0$strCount';
}

String formatBigNumber(int num) {
  if (num < 1000) {
    return num.toString();
  } else if (num < 1000000) {
    return (num/1000).toStringAsFixed(1) + 'k';
  } else {
    return (num/1000000).toStringAsFixed(1) + 'm';
  }
}

/// 随机获取指定返回内的数值
///
/// from [min] 含，to [max] 含
int getRandomRangeInt(int min, int max) {
  final Random random = Random();
  return min + random.nextInt(max + 1 - min);
}

/// 转为 rpx 单位
///
/// [size] 设计稿上的大小
///
/// [width] 设计稿尺寸
double toRpx({double size = 0, double width = 750}) {
  // 原生：MediaQuery.of(context).size.width / 750;
  double rpx = Get.width / width;
  return size * rpx;
}

/// 网络图默认图
String networkImageToDefault(String? src) {
  return src ??
      Constants.PROFILE_IMAGE_DEFAULT_URL;
}

/*

  * 生成固定长度的随机字符串

  * */

String getRandom(int num) {

String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';

String left = '';

for (var i = 0; i < num; i++) {

//    right = right + (min + (Random().nextInt(max - min))).toString();

left = left + alphabet[Random().nextInt(alphabet.length)];

}

return left;

}


/// 获取日期

String getDate() {

  DateTime now = DateTime.now();

  String month = now.month > 9 ? '${now.month}' : '0${now.month}';
  String day = now.day > 9 ? '${now.day}' : '0${now.day}';
  return '${now.year}$month$day';

}

String getDateString(DateTime time) {

  String month = time.month > 9 ? '${time.month}' : '0${time.month}';
  String day = time.day > 9 ? '${time.day}' : '0${time.day}';
  return '${time.year}$month$day';
}

String getTimeString(DateTime? time) {
  if (time == null) {
    return '-';
  }
  String hour = time.hour > 9 ? '${time.hour}' : '0${time.hour}';
  String minute = time.minute > 9 ? '${time.minute}' : '0${time.minute}';
  return '$hour${minute}hrs';
}

String getDateTimeString(DateTime time) {

  String month = time.month > 9 ? '${time.month}' : '0${time.month}';
  String day = time.day > 9 ? '${time.day}' : '0${time.day}';
  String hour = time.hour > 9 ? '${time.hour}' : '0${time.hour}';
  String minute = time.minute > 9 ? '${time.minute}' : '0${time.minute}';
  return '${time.year}-$month-$day $hour:$minute';
}

String dateToAlphaMonth(String? date) {
  if (date == null) {
    return '';
  }
  DateTime dateTime = DateTime.parse(date).toLocal();
  // String month = date.substring(5,7);
  int month = dateTime.month;
  String day = dateTime.day > 9 ? '${dateTime.day}' : '0${dateTime.day}';
  // String day = date.substring(8,10)..replaceAll('0', '');
  switch(month) {
    case 1:
      return '$day Jan';
    case 2:
      return '$day Feb';
    case 3:
      return '$day Mar';
    case 4:
      return '$day Apr';
    case 5:
      return '$day May';
    case 6:
      return '$day Jun';
    case 7:
      return '$day Jul';
    case 8:
      return '$day Aug';
    case 9:
      return '$day Sep';
    case 10:
      return '$day Oct';
    case 11:
      return '$day Nov';
    case 12:
      return '$day Dec';
    default:
      return '';
  }
}

String dateToAlphaTime(String? date) {
  if (date == null) {
    return '';
  }
  if (date.length < 16) {
    return '';
  }
  int hour = int.parse(date.substring(11,13));
  String minute = date.substring(14,16);
  if (hour > 12) {
    return '${hour - 12}:$minute pm';
  } else if (hour == 12) {
    return '$hour:$minute pm';
  } else {
    return '$hour:$minute am';
  }

}

double fitSize(double size) {
  return size/window.devicePixelRatio;
}
