import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:basic_timer_app/utils.dart';
import 'package:flutter/material.dart';

final customWidth01 =
    CustomSliderWidths(trackWidth: 2, progressBarWidth: 10, shadowWidth: 20);
final customColors01 = CustomSliderColors(
    dotColor: Colors.white.withOpacity(0.8),
    trackColor: HexColor('#FFD4BE').withOpacity(0.4),
    progressBarColor: HexColor('#F6A881'),
    shadowColor: HexColor('#FFD4BE'),
    shadowStep: 10.0,
    shadowMaxOpacity: 0.6);

final CircularSliderAppearance slider_appearance01 = CircularSliderAppearance(
    customWidths: customWidth01,
    customColors: customColors01,
    animationEnabled: false,
    startAngle: 270,
    angleRange: 360,
    size: 350.0,);

final customWidth02 =
    CustomSliderWidths(trackWidth: 5, progressBarWidth: 15, shadowWidth: 30);
final customColors02 = CustomSliderColors(
    dotColor: Colors.white.withOpacity(0.8),
    trackColor: HexColor('#98DBFC').withOpacity(0.3),
    progressBarColor: HexColor('#6DCFFF'),
    shadowColor: HexColor('#98DBFC'),
    shadowStep: 15.0,
    shadowMaxOpacity: 0.3);

final CircularSliderAppearance slider_appearance02 = CircularSliderAppearance(
    customWidths: customWidth02,
    customColors: customColors02,
    animationEnabled: false,
    startAngle: 270,
    angleRange: 360,
    size: 290.0,);

final customWidth03 =
    CustomSliderWidths(trackWidth: 8, progressBarWidth: 20, shadowWidth: 40);
final customColors03 = CustomSliderColors(
    dotColor: Colors.white.withOpacity(0.8),
    trackColor: HexColor('#EFC8FC').withOpacity(0.3),
    progressBarColor: HexColor('#A177B0'),
    shadowColor: HexColor('#EFC8FC'),
    shadowStep: 20.0,
    shadowMaxOpacity: 0.3);

final CircularSliderAppearance slider_appearance03 = CircularSliderAppearance(
    customWidths: customWidth03,
    customColors: customColors03,
    animationEnabled: false,
    startAngle: 270,
    angleRange: 360,
    size: 210.0,);