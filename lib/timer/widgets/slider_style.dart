import 'package:basic_timer_app/static/style.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:basic_timer_app/utils.dart';
import 'package:flutter/material.dart';

final customWidth =
    CustomSliderWidths(trackWidth: 5, progressBarWidth: 20, shadowWidth: 30);
final customColors = CustomSliderColors(
    dotColor: Colors.white.withOpacity(0.8),
    trackColor: AppColors.primaryColor.withOpacity(0.3),
    progressBarColor: AppColors.primaryColor,
    shadowColor: AppColors.backGround,
    shadowStep: 15.0,
    shadowMaxOpacity: 0.3);

final CircularSliderAppearance slider_appearance = CircularSliderAppearance(
    customWidths: customWidth,
    customColors: customColors,
    animationEnabled: false,
    startAngle: 270,
    angleRange: 360,
    size: 325.0,);