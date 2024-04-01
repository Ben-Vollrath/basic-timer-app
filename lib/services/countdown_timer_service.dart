import 'dart:async';
  import 'package:flutter/foundation.dart'; // Import the package that contains the ValueChanged class.


class CountdownTimerService {
  Timer _timer;
  int _current;

  CountdownTimerService()
      : _current = 0,
        _timer = Timer(Duration.zero, () {}) {
    _timer = Timer(Duration.zero, () {});
  }


  void start(double start, ValueChanged<double> onTick) {
    double _current = start;
    const tenMillisecond = Duration(milliseconds: 10);
    _timer = Timer.periodic(
      tenMillisecond,
      (Timer timer) {
        if (_current < 0.01) {
          timer.cancel();
        } else {
          _current = _current - 0.01;
          onTick(_current);
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