import 'dart:async';
import 'package:flutter/foundation.dart'; // Import the package that contains the ValueChanged class.

  class TimerValues {
    final double hours;
    final double minutes;
    final double seconds;

    TimerValues(this.hours, this.minutes, this.seconds);
  }


class CountdownTimerService {
  Timer _timer;
  final int _current;

  CountdownTimerService()
      : _current = 0,
        _timer = Timer(Duration.zero, () {}) {
    _timer = Timer(Duration.zero, () {});
  }


  void start(double hours, double minutes, double seconds, ValueChanged<TimerValues> onTick) {
    _timer = Timer.periodic(
      Duration(milliseconds: 10),
      (Timer timer) {
        
        if (hours <= 0 && minutes <= 0 && seconds < 0.01) {
          onTick(TimerValues(0, 0, 0));
          timer.cancel();
        } else {
          if(seconds - 0.01 >= 0){
            seconds -= 0.01;
          }
          else{
            if(minutes - 1 >= 0){
              seconds = 60.00;
              minutes -= 1;
            }
            else{
              if(hours - 1 >= 0){
                minutes = 60;
                hours -= 1;
              }
              else{
                hours = 0;
              }
            }
          }

          onTick(TimerValues(hours, minutes, seconds));

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