

import 'dart:async';
import 'dart:io';

class MyTimer {

  static MyTimer _instance = MyTimer._internal();

  factory MyTimer() => _instance;

  Timer? _timer;

  MyTimer._internal() {
    if (_timer == null) {
      _init();
    }
  }

  void _init() {
    const Duration duration = Duration(seconds: 5);

    _timer = Timer.periodic(duration, (timer) {
      // TODO
    });
  }

  void _onTimeUp() {
  }

  void resetTimer() {
  }
}