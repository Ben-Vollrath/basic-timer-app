import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:basic_timer_app/static/colors.dart';
import 'package:basic_timer_app/timer/providers/start_timer_button_animation.dart';
import 'package:basic_timer_app/timer/widgets/filling_container.dart';
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

  bool buttonClicked = false;
  ValueNotifier<double> startButtonHeight = ValueNotifier(250.00);
  ValueNotifier<double> buttonOpacity = ValueNotifier(1.0);

  double selectedSeconds = 00;
  double selectedMinutes = 00;
  double selectedHours = 00;

  ValueNotifier<double> currentSeconds = ValueNotifier(00);
  ValueNotifier<double> currentMinutes = ValueNotifier(00);
  ValueNotifier<double> currentHours = ValueNotifier(00);

  late ResetTimerAnimation resetTimerAnimation;
  late startTimerButtonAnimation startimerButtonAnimation;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return ValueListenableBuilder(
      valueListenable: startButtonHeight, //Placeholder
      builder: (context, value, child) {
      return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: timer(), // Centered vertically in the stack.
            ),
            Positioned(
              top: screenHeight / 2 + value, // Adjust the value to position startButton() right below timer()
              child: animatedStartButton(),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    resetTimerAnimation = ResetTimerAnimation(
      vsync: this, 
      currentSeconds: currentSeconds, 
      currentMinutes: currentMinutes, 
      currentHours: currentHours
      );

    startimerButtonAnimation = startTimerButtonAnimation(
      vsync: this,
      startButtonHeight: startButtonHeight,
      opacity: buttonOpacity,
      );
  }

  void startTimer() {
    
    timerService.start(selectedHours, selectedMinutes, selectedSeconds, (TimerValues currentValues) {
      currentHours.value = currentValues.hours;
      currentMinutes.value = currentValues.minutes;
      currentSeconds.value =  currentValues.seconds;
      if(currentValues.hours == 0 && currentValues.minutes == 0 && currentValues.seconds == 0){
        cancelOrEndTimer();
      }
    });
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
                              padding: EdgeInsets.all(35),
                              child: showTime(),
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

  GestureDetector animatedStartButton(){
    return GestureDetector(
      onTap: () {
        setState(() {
          buttonClicked = !buttonClicked;
        });
        startTimer();
        startimerButtonAnimation.moveUpController.forward(from: 0);
      },
      child: ValueListenableBuilder(
        valueListenable: buttonOpacity,
        builder: (context, value, child){
          return Opacity(
            opacity: value,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: buttonClicked ? 30.0 : 180.0,
              height: buttonClicked ? 30.0 : 70.0,
              decoration: BoxDecoration(
                color: AppColors.mainOrange,
                borderRadius: buttonClicked ? BorderRadius.circular(35) : BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  buttonClicked ? '' : 'Start',
                  style: TextStyle(
                    color: AppColors.backgroundWhite,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
  GestureDetector showTime(){
  return GestureDetector(
    onTap: () {
      cancelOrEndTimer();
    },
    child: ValueListenableBuilder(
      valueListenable: buttonOpacity,
      builder: (context, value, child) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(140),
            border: Border.all(
              color: AppColors.black, 
              width: 3
            ),
              color: AppColors.red.withOpacity(1 - value as double), //change color
          ),
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
    },
    ),
  );
  }

  void cancelOrEndTimer(){
      timerService.cancel();
      resetTimerAnimation.playAnimation();
      startimerButtonAnimation.fadeController.reverse();
      buttonClicked = false;
  }
}