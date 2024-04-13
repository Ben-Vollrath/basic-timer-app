import 'dart:async';
import 'package:flutter/foundation.dart'; // Import the package that contains the ValueChanged class.

class CountdownTimerService {
  Timer _timer;
  final int _current;

  CountdownTimerService()
      : _current = 0,
        _timer = Timer(Duration.zero, () {}) {
    _timer = Timer(Duration.zero, () {});
  }


  void start(double minutes, ValueChanged<Duration> onTick) {

    DateTime startTime = DateTime.now();
    DateTime endTime = startTime.add(Duration(minutes: minutes.toInt()));

    Duration timeLeft = endTime.difference(startTime);

    _timer = Timer.periodic(
      Duration(milliseconds: 10),
      (Timer timer) {
          Duration timeLeft = endTime.difference(DateTime.now());          
          if(timeLeft.isNegative) {
            timer.cancel();
          }
          onTick(timeLeft);
          }

    );
  }

  void cancel() {
    _timer.cancel();

  }


  bool isRunning() {
    return _timer.isActive;
  }
}