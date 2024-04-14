import 'package:basic_timer_app/utils.dart';
import 'package:flutter/material.dart';

class AppColors {
  static var backGround = HexColor('#FAFAFA');

  static var primaryColor = HexColor('#4AB5B5');
  static var textStrong = HexColor('#2F4F4F');
  static var textWeak = HexColor('#778899');
  static var strokeStrong = HexColor('#5F9EA0');
  static var strokeWeak = HexColor('#AFD5D8');
  static var fill = HexColor('#B0E0E6');

}

class AppTextStyle {
  static var title = TextStyle(
    color: AppColors.textStrong,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    wordSpacing: 1.5,
  );

  static var subtitle = TextStyle(
    color: AppColors.textStrong,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    wordSpacing: 1.25,
  );

  static var body = TextStyle(
    color: AppColors.textWeak,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    wordSpacing: 1
  );

  static var button = TextStyle(
    color: AppColors.backGround,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
} 