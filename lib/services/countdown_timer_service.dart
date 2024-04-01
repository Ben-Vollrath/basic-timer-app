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


  void start(double start, ValueChanged<double> onTick) {
    double current = start;
    const tenMillisecond = Duration(milliseconds: 10);
    _timer = Timer.periodic(
      tenMillisecond,
      (Timer timer) {
        if (current < 0.01) {
          timer.cancel();
        } else {
          current = current - 0.01;
          onTick(current);
        }
      },
    );
  }

  void cancel() {
    _timer.cancel();
  }


  bool isRunning() {
    return _timer.isActive;
  }
}