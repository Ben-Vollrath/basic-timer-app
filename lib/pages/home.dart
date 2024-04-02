// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:basic_timer_app/services/countdown_timer_service.dart';
import 'package:basic_timer_app/styling/slider_style.dart';
import 'package:basic_timer_app/widgets/filling_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CountdownTimerService timerService = CountdownTimerService();

  ValueNotifier<double> fillValue = ValueNotifier(0); 

  double currentSeconds = 00;
  double currentMinutes = 00;
  double currentHours = 00;

  Timer? holdFillTimer;
  Timer? fillBackTimer;

  void startTimer(double hours, double minutes, double seconds) {
    
    timerService.start(hours, minutes, seconds, (TimerValues currentValues) {
      setState(() {
        currentHours = currentValues.hours;
        currentMinutes = currentValues.minutes;
        currentSeconds =  currentValues.seconds;
      });
    });
  }

  void resetTimerAnimation(){
    Timer.periodic(const Duration(microseconds: 100), (timer) {
        if(currentHours <= 0 && currentMinutes <= 0 && currentSeconds <= 0){
          timer.cancel();
        }
        setState(() {
        currentHours = currentHours - currentHours*0.01 >= 0 ? currentHours - currentHours*0.01 : 0;
        currentMinutes = currentMinutes - currentMinutes*0.01 >= 0 ? currentMinutes - currentMinutes*0.01 : 0;
        currentSeconds =  currentSeconds - currentSeconds*0.01 >= 0 ? currentSeconds - currentSeconds*0.01 : 0;
      });
  });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: timer(),
    );
  }

  Center timer() {
    return Center(
      child: Align(
        alignment: Alignment.center,
        child: SleekCircularSlider(
          initialValue: currentSeconds,
          min: 0,
          max: 60,
          onChange: (double value)  {
            currentSeconds = value;
          },
          appearance: slider_appearance01,
          innerWidget: (double value){
            return Align(
              alignment: Alignment.center,
              child: SleekCircularSlider(
                initialValue: currentMinutes,
                min: 0,
                max: 60,
                onChange: (double value) {
                  currentMinutes = value;
                },
                appearance: slider_appearance02,
                innerWidget: (double value) {
                  return Align(
                    alignment: Alignment.center,
                    child: SleekCircularSlider(
                      initialValue: currentHours,
                      min: 0,
                      max: 24,
                      onChange: (double value) {
                        currentHours = value;
                      },
                      appearance: slider_appearance03,
                      innerWidget: (double value) {
                        return Container(
                        padding: EdgeInsets.all(18),
                        child: detectStartTimer(),
                      );
                      }
                    ),
                  );
                }
              ),
            );
          }
        ),
      )
    );
  }
  GestureDetector detectStartTimer() {
    return GestureDetector(
    onTapDown: (details) {
      fillBackTimer?.cancel();
      if(!timerService.isRunning()){
        holdFillTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        if (fillValue.value < 1) {
          fillValue.value += 0.01;
        } else {
          timer.cancel();
          
          startTimer(currentHours, currentMinutes, currentSeconds);
        }
        });
      }
      else{
        holdFillTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        if (fillValue.value > 0) {
          fillValue.value -= 0.01;
        } else {
          timer.cancel();
          timerService.cancel();

          resetTimerAnimation();
        }
        });
      }
    },
    onTapUp: (details){
      holdFillTimer?.cancel();

      fillTimerAnimation();
    },
    child: ValueListenableBuilder(
      valueListenable: fillValue,
      builder: (context, value, child) {
        return FillingContainer(
          progress: value,
          size: 210,
          backgroundColor: Colors.white,
          progressColor: customColors03.trackColor!,
          child: Center(
            child: Text(
                '${currentHours.floor().toString().padLeft(2, '0')}:${currentMinutes.floor().toString().padLeft(2, '0')}:${currentSeconds.floor().toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    ),
            );
  }

  void fillTimerAnimation() {
    fillBackTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if(timerService.isRunning()){
        if (fillValue.value < 1) {
          fillValue.value += 0.005;
        } 
        else {
          timer.cancel();
        }
      }
      else{
      if (fillValue.value > 0) {
        fillValue.value -= 0.005;
      } 
      else {
        timer.cancel();
        timerService.cancel();
      }
        
      }
    });
  }

  @override
  void dispose() {
    timerService.cancel();
    super.dispose();
  }
}



