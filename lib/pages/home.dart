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

  String currentSeconds = '00';
  String currentMinutes = '00';
  String currentHours = '00';

  Timer? fillTimer;

  final TextEditingController _controller = TextEditingController();

  void startTimer(double hours, double minutes, double seconds) {
    double totalSeconds = (hours * 3600) + (minutes * 60) + seconds;
    timerService.start(totalSeconds, (double current) {
      setState(() {
        currentHours = (current ~/ 3600).toString().padLeft(2, '0');
        currentMinutes = ((current % 3600) ~/ 60).toString().padLeft(2, '0');
        currentSeconds = (current % 60).toString().padLeft(2, '0');
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
          initialValue: double.parse(currentSeconds),
          min: 0,
          max: 60,
          onChange: (double value)  {
            currentSeconds = value.floor().toString();
          },
          appearance: slider_appearance01,
          innerWidget: (double value){
            return Align(
              alignment: Alignment.center,
              child: SleekCircularSlider(
                initialValue: double.parse(currentMinutes),
                min: 0,
                max: 60,
                onChange: (double value) {
                  currentMinutes = value.floor().toString();
                },
                appearance: slider_appearance02,
                innerWidget: (double value) {
                  return Align(
                    alignment: Alignment.center,
                    child: SleekCircularSlider(
                      initialValue: double.parse(currentHours),
                      min: 0,
                      max: 24,
                      onChange: (double value) {
                        currentHours = value.floor().toString();
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
      if(!timerService.isRunning()){
        fillTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        if (fillValue.value < 1) {
          fillValue.value += 0.01;
        } else {
          timer.cancel();
          
          startTimer(double.parse(currentHours), double.parse(currentMinutes), double.parse(currentSeconds));
        }
        });
      }
      else{
        fillTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        if (fillValue.value > 0) {
          fillValue.value -= 0.01;
        } else {
          timer.cancel();
          timerService.cancel();
        }
        });
      }
    },
    onTapUp: (details){
      fillTimer?.cancel();

      if(!timerService.isRunning()){
        fillValue.value = 0;
      }
      else{
        fillValue.value = 1;
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
                '${currentHours.padLeft(2, '0')}:${currentMinutes.padLeft(2, '0')}:${currentSeconds.padLeft(2, '0')}',
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



