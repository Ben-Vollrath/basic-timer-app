import 'package:basic_timer_app/timer/widgets/filling_container.dart';
import 'package:flutter/material.dart';

import 'package:basic_timer_app/timer/domain/services/countdown_timer_service.dart';
import 'package:basic_timer_app/utils.dart';
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

  double selectedSeconds = 00;
  double selectedMinutes = 00;
  double selectedHours = 00;

  ValueNotifier<double> currentSeconds = ValueNotifier(00);
  ValueNotifier<double> currentMinutes = ValueNotifier(00);
  ValueNotifier<double> currentHours = ValueNotifier(00);

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
            top: screenHeight / 2 + 250, // Adjust the value to position startButton() right below timer()
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
      currentMinutes: currentMinutes, 
      currentHours: currentHours
      );
  }

  void startTimer() {
    
    timerService.start(selectedHours, selectedMinutes, selectedSeconds, (TimerValues currentValues) {
      currentHours.value = currentValues.hours;
      currentMinutes.value = currentValues.minutes;
      currentSeconds.value =  currentValues.seconds;
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
        //TODO add stop timer functionality
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: buttonClicked ? 30.0 : 180.0,
        height: buttonClicked ? 30.0 : 70.0,
        decoration: BoxDecoration(
          color: HexColor('#F6A881'),
          borderRadius: buttonClicked ? BorderRadius.circular(35) : BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            buttonClicked ? '' : 'Start',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
  FillingContainer showTime(){
  return FillingContainer(
    progress: 0,
    size: 140,
    backgroundColor: HexColor('#FDFDF4'),
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
}