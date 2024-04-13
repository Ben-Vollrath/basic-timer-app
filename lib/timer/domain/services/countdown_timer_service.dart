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


  void start(Duration timerDuration, ValueChanged<Duration> onTick) {

    DateTime startTime = DateTime.now();
    DateTime endTime = startTime.add(timerDuration);

    Duration timeLeft = endTime.difference(startTime);

    _timer = Timer.periodic(
      Duration(milliseconds: 100),
      (Timer timer) {
          timeLeft = endTime.difference(DateTime.now());          
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