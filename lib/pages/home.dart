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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  final CountdownTimerService timerService = CountdownTimerService();

  late AnimationController fillController;
  late Animation<double> fillAnimation;

  late AnimationController fillBackController;
  late Animation<double> fillBackAnimation;

  ValueNotifier<double> fillValue = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    fillController = AnimationController(
      duration: const Duration(seconds: 2),
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
          resetTimerAnimation();
        }
      }
    });

    fillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(fillController)..addListener(() {
      fillValue.value = fillAnimation.value;
    });

    fillBackController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    fillBackAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(fillBackController)..addListener(() {
      fillValue.value = fillBackAnimation.value;
    });

  }


  double currentSeconds = 00;
  double currentMinutes = 00;
  double currentHours = 00;

  void startTimer() {
    
    timerService.start(currentHours, currentMinutes, currentSeconds, (TimerValues currentValues) {
      setState(() {
        currentHours = currentValues.hours;
        currentMinutes = currentValues.minutes;
        currentSeconds =  currentValues.seconds;
      });
    });
  }

  void resetTimerAnimation(){
    //TODO: Redo this
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
      fillBackController.stop();
      
      if(timerService.isRunning()){
        fillController.reverse(from: fillValue.value);
      }
      else{
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

  @override
  void dispose() {
    timerService.cancel();
    super.dispose();
  }
}



