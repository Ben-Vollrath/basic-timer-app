import 'package:flutter/material.dart';

class ResetTimerAnimation {
  late AnimationController controller;
  late Animation<double> animation;
  
  // References to the ValueNotifiers passed in through the constructor
  ValueNotifier<double> currentMinutes;

  // Initial values to be captured when the animation starts
  late double initialMinutesValue;

  ResetTimerAnimation({
    required TickerProvider vsync,
    required this.currentMinutes,
  }) {
    controller = AnimationController(
      duration: const Duration(milliseconds: 1250),
      vsync: vsync,
    );

    CurvedAnimation curve = CurvedAnimation(
      parent: controller,
      curve: Curves.fastEaseInToSlowEaseOut,
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(updateValues);
  }

  void captureInitialValues() {
    initialMinutesValue = currentMinutes.value;
  }

  void updateValues() {
    currentMinutes.value = initialMinutesValue * (1 - animation.value);
  }

  void playAnimation() {
    captureInitialValues(); // Capture initial values before the animation starts
    controller.forward(from: 0.0);
  }

  void dispose() {
    controller.dispose();
  }
}
