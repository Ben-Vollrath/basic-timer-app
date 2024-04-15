import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:basic_timer_app/static/style.dart';
import 'package:basic_timer_app/timer/domain/services/countdown_timer_service.dart';
import 'package:flutter/widgets.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:basic_timer_app/timer/widgets/slider_style.dart';
import 'package:basic_timer_app/timer/providers/reset_timer_animation.dart';

class InteractiveTimer extends StatefulWidget {
  const InteractiveTimer({super.key});

  @override
  State<InteractiveTimer> createState() => _InteractiveTimerState();
}

class _InteractiveTimerState extends State<InteractiveTimer> with TickerProviderStateMixin {
  final CountdownTimerService timerService = CountdownTimerService();

  ValueNotifier<bool> buttonClicked = ValueNotifier(false);


  double selectedSeconds = 00;
  ValueNotifier<double> currentSeconds = ValueNotifier(00);


  late ResetTimerAnimation resetTimerAnimation;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: timer(), // Centered vertically in the stack.
          ),
          Positioned(
            top: screenHeight / 2 + 225, // Adjust the value to position startButton() right below timer()
            child: animatedStartButton(),
          ),
        ],
      );
  }

  @override
  void initState() {
    super.initState();
    resetTimerAnimation = ResetTimerAnimation(
      vsync: this, 
      currentSeconds: currentSeconds, 
      );
  }

  void startTimer() {
    Duration timerDuration = Duration(seconds: selectedSeconds.toInt());
    timerService.start(timerDuration, (Duration timeLeft) {
      if(timeLeft.isNegative){
        cancelOrEndTimer();
        currentSeconds.value = 0;
      }
      else{
        currentSeconds.value = timeLeft.inSeconds.toDouble();
      }
    });
  }

  
  Center timer() {
    return Center(
      child: ValueListenableBuilder(
        valueListenable: currentSeconds,
        builder: (context, value, child) {
          return SleekCircularSlider(
            initialValue: value,
            min: 0,
            max: 3600,
            onChange: timerService.isRunning() ? null : (double value) {
              selectedSeconds = value;
            },
            appearance: slider_appearance,
            innerWidget: (double value) {
              return Container(
              padding: EdgeInsets.all(80),
              child: showTime(),
            );
            }
          );
        }
    )
    );
  }

  Container animatedStartButton(){
    return Container(
      width: 150,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        onPressed: () {
          if(timerService.isRunning()){
            cancelOrEndTimer();
            return;
          } 
          else{
            startTimer();
          }
          buttonClicked.value = !buttonClicked.value;
        },
        child: Center(
          child: ValueListenableBuilder(
            valueListenable: buttonClicked,
            builder: (context, value, child){
            return Text(
              value ? 'Cancel' : 'Start',
              style: TextStyle(
                color: AppColors.backGround,
                fontSize: 30,
              ),
            );
          }
          ),
        ),
      ),
    );
  }
  Container showTime(){
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(140),
        border: Border.all(
          color: AppColors.backGround, 
          width: 3
        ),
      ),
    child: Center(
      child: Text(
          '00:${( (timerService.isRunning() ? currentSeconds.value : selectedSeconds) ~/ 60 ).toString().padLeft(2, '0')}:${(timerService.isRunning() ? currentSeconds.value : selectedSeconds).remainder(60).round().toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: 35,
            color: AppColors.textStrong,
          ),
        textAlign: TextAlign.center,
      ),
    ),
  );
  }

  void cancelOrEndTimer(){
      timerService.cancel();
      resetTimerAnimation.playAnimation();
      buttonClicked.value = false;
  }

  @override
  void dispose() {
    timerService.cancel();
    resetTimerAnimation.dispose();
    super.dispose();
  }
}