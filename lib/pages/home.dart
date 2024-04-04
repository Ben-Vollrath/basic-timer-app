// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:basic_timer_app/services/countdown_timer_service.dart';
import 'package:basic_timer_app/styling/slider_style.dart';
import 'package:basic_timer_app/widgets/filling_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  final CountdownTimerService timerService = CountdownTimerService();

  late AnimationController fillController;
  late Animation<double> fillAnimation;

  late AnimationController fillBackController;
  late Animation<double> fillBackAnimation;

  late AnimationController resetTimerController;
  late Animation<double>resetTimerAnimation;

  ValueNotifier<double> fillValue = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    fillController = AnimationController(
      duration: const Duration(milliseconds: 1250),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if(!timerService.isRunning()){
          startTimer();
        }
      }
      else if(status == AnimationStatus.dismissed){
        if(timerService.isRunning()){
          timerService.cancel();
          playResetTimerAnimation();
        }
      }
    });
    CurvedAnimation curveFillAnimation = CurvedAnimation(parent: fillController, curve: Curves.easeInOut);
    fillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curveFillAnimation)..addListener(() {
      fillValue.value = fillAnimation.value;
    });

    fillBackController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    CurvedAnimation curveFillBackAnimation = CurvedAnimation(parent: fillBackController, curve: Curves.easeInOut);
    fillBackAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curveFillBackAnimation)..addListener(() {
      fillValue.value = fillBackAnimation.value;
    });

    resetTimerController = AnimationController(
      duration: const Duration(milliseconds: 1250),
      vsync: this,
    );

    CurvedAnimation curveResetTimerAnimation = CurvedAnimation(parent: resetTimerController, curve: Curves.easeInOut);
    resetTimerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curveResetTimerAnimation)..addListener(() {
        currentSeconds.value = initialSeconds*(1-resetTimerAnimation.value);
        currentMinutes.value = initialMinutes*(1-resetTimerAnimation.value);
        currentHours.value = initialHours*(1-resetTimerAnimation.value);
    });

  }

  double selectedSeconds = 00;
  double selectedMinutes = 00;
  double selectedHours = 00;

  double initialSeconds = 00;
  double initialMinutes = 00;
  double initialHours = 00;

  ValueNotifier<double> currentSeconds = ValueNotifier(00);
  ValueNotifier<double> currentMinutes = ValueNotifier(00);
  ValueNotifier<double> currentHours = ValueNotifier(00);

  void startTimer() {
    
    timerService.start(selectedHours, selectedMinutes, selectedSeconds, (TimerValues currentValues) {
      currentHours.value = currentValues.hours;
      currentMinutes.value = currentValues.minutes;
      currentSeconds.value =  currentValues.seconds;
    });
  }

  void playResetTimerAnimation(){
    //TODO: Redo this
    /*
    double reductionPercentage = 0.008;
    Timer.periodic(const Duration(microseconds: 100), (timer) {
        if(currentHours <= 0 && currentMinutes <= 0 && currentSeconds <= 0){
          timer.cancel();
        }
        setState(() {
        currentHours = reduceByPercentageIfNotNull(currentHours, reductionPercentage);
        currentMinutes = reduceByPercentageIfNotNull(currentMinutes, reductionPercentage);
        currentSeconds = reduceByPercentageIfNotNull(currentSeconds, reductionPercentage);
      });
    });
    */
    initialSeconds = currentSeconds.value;
    initialMinutes = currentMinutes.value;
    initialHours = currentHours.value;

    resetTimerController.forward(from: 0.0);


  }


  double reduceByPercentageIfNotNull(double value, double percentage){
    return value - value*percentage >= 0 ? value - value*percentage : 0;
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
        child: ValueListenableBuilder(
          valueListenable: currentSeconds,
          builder: (context, currentSecondschanged, child) {
          return SleekCircularSlider(
            initialValue: currentSecondschanged,
            min: 0,
            max: 60,
            onChange: (double value)  {
              selectedSeconds = value;
            },
            appearance: slider_appearance01,
            innerWidget: (double value){
              return Align(
                alignment: Alignment.center,
                child: ValueListenableBuilder(
                  valueListenable: currentMinutes,
                  builder : (context, currentMinuteschanged, child) {
                  return SleekCircularSlider(
                    initialValue: currentMinuteschanged,
                    min: 0,
                    max: 60,
                    onChange: (double value) {
                      selectedMinutes = value;
                    },
                    appearance: slider_appearance02,
                    innerWidget: (double value) {
                      return Align(
                        alignment: Alignment.center,
                        child: ValueListenableBuilder(
                          valueListenable: currentHours,
                          builder: (context, currentHourschanged, child) {
                            return SleekCircularSlider(
                            initialValue: currentHourschanged,
                            min: 0,
                            max: 24,
                            onChange: (double value) {
                              selectedHours = value;
                            },
                            appearance: slider_appearance03,
                            innerWidget: (double value) {
                              return Container(
                              padding: EdgeInsets.all(18),
                              child: detectStartTimer(),
                            );
                            }
                          );
                        }
                        ),
                      );
                    }
                  );
                }
                ),
              );
            }
          );
        }
        ),
      )
    );
  }
  GestureDetector detectStartTimer() {
    return GestureDetector(
    onTapDown: (details) {
      fillBackController.stop();
      
      if(timerService.isRunning()){
        fillController.reverse(from: fillValue.value);
      }
      else if(selectedHours > 0 || selectedMinutes > 0 || selectedSeconds > 0){
        fillController.forward(from: fillValue.value);
      }
    },
    onTapUp: (details){
      fillController.stop();

      if(timerService.isRunning()){
        fillBackController.forward(from: fillValue.value);
      }
      else{
        fillBackController.reverse(from: fillValue.value);
      }
      
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
                '${selectedHours.floor().toString().padLeft(2, '0')}:${selectedMinutes.floor().toString().padLeft(2, '0')}:${selectedSeconds.floor().toString().padLeft(2, '0')}',
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

  @override
  void dispose() {
    timerService.cancel();
    super.dispose();
  }
}



