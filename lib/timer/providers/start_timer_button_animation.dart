import 'package:flutter/material.dart';

class startTimerButtonAnimation{
  late AnimationController moveUpController;
  late Animation<double> moveUpAnimation;

  late ValueNotifier<double> startButtonHeight;

  late AnimationController fadeController;
  late Animation<double> fadeAnimation;

  late ValueNotifier<double> opacity;
  

  startTimerButtonAnimation({
    required TickerProvider vsync,
    required this.startButtonHeight,
    required this.opacity,
  }) {
    moveUpController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: vsync,
    );

    CurvedAnimation curve = CurvedAnimation(
      parent: moveUpController,
      curve: Curves.fastEaseInToSlowEaseOut,
    );

    moveUpAnimation = Tween<double>(begin: 250.00, end: -15.00).animate(curve)
      ..addListener(
        () => startButtonHeight.value = moveUpAnimation.value,
      );

    moveUpAnimation.addStatusListener((status) { 
      if (status == AnimationStatus.completed) {
        //do 
        fadeController.forward();

        
      }
    });

    fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    );

    CurvedAnimation fadeCurve = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeIn,
    );

    fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(fadeCurve)
      ..addListener(
        () { 
          opacity.value = fadeAnimation.value;
        }
      );

    fadeAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
      }
    });

  }


}