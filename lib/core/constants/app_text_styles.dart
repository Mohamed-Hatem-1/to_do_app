import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle lang = TextStyle(
    color: AppColors.primary,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle forgotPassword = TextStyle(
    fontSize: 12,
    color: AppColors.greyText,
  );

  static const TextStyle button = TextStyle(
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    fontSize: 14,
    color: Colors.white,
  );

  static const TextStyle bottomText = TextStyle(
    color: AppColors.greyText,
  );

  static const TextStyle bottomLink = TextStyle(
    color: AppColors.primary,
    fontWeight: FontWeight.w700,
  );
}