import 'package:basic_timer_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:basic_timer_app/timer/domain/services/countdown_timer_service.dart';
import 'package:basic_timer_app/timer/widgets/slider_style.dart';
import 'package:basic_timer_app/timer/widgets/filling_container.dart';
import 'package:basic_timer_app/timer/providers/reset_timer_animation.dart';
import 'package:basic_timer_app/timer/widgets/animated_start_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  final CountdownTimerService timerService = CountdownTimerService();
  bool _buttonClicked = false;

  double selectedSeconds = 00;
  double selectedMinutes = 00;
  double selectedHours = 00;

  ValueNotifier<double> currentSeconds = ValueNotifier(00);
  ValueNotifier<double> currentMinutes = ValueNotifier(00);
  ValueNotifier<double> currentHours = ValueNotifier(00);

  late AnimationController fillController;
  late Animation<double> fillAnimation;

  late AnimationController fillBackController;
  late Animation<double> fillBackAnimation;

  late ResetTimerAnimation resetTimerAnimation;

  ValueNotifier<double> fillValue = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    resetTimerAnimation = ResetTimerAnimation(
      vsync: this, 
      currentSeconds: currentSeconds, 
      currentMinutes: currentMinutes, 
      currentHours: currentHours
      );

    //Remove this with new start animation
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
          resetTimerAnimation.playAnimation();
        }
      }
    });
    CurvedAnimation curveFillAnimation = CurvedAnimation(parent: fillController, curve: Curves.easeOut);
    fillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curveFillAnimation)..addListener(() {
      fillValue.value = fillAnimation.value;
    });

    fillBackController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    CurvedAnimation curveFillBackAnimation = CurvedAnimation(parent: fillBackController, curve: Curves.easeInOut);
    fillBackAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curveFillBackAnimation)..addListener(() {
      fillValue.value = fillBackAnimation.value;
    });

  }


  void startTimer() {
    
    timerService.start(selectedHours, selectedMinutes, selectedSeconds, (TimerValues currentValues) {
      currentHours.value = currentValues.hours;
      currentMinutes.value = currentValues.minutes;
      currentSeconds.value =  currentValues.seconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: HexColor('#FDFDF4'),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: timer(), // Centered vertically in the stack.
          ),
          Positioned(
            top: screenHeight / 2 + 250, // Adjust the value to position startButton() right below timer()
            child: AnimatedStartButton(),
          ),
        ],
      ),
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
                              padding: EdgeInsets.all(35),
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
    ),
            );
  }
}



