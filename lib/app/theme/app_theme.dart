// lib/app/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class AppColors {
  static const black   = Color(0xFF0A0A0A);
  static const card    = Color(0xFF141414);
  static const card2   = Color(0xFF1C1C1C);
  static const border  = Color(0xFF232323);
  static const yellow  = Color(0xFFFFD600);
  static const white   = Color(0xFFFFFFFF);
  static const textSub = Color(0xFF888888);
  static const textDim = Color(0xFF444444);
  static const success = Color(0xFF52E37A);
  static const danger  = Color(0xFFF87171);
}

abstract class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3:            true,
    brightness:              Brightness.dark,
    scaffoldBackgroundColor: AppColors.black,
    fontFamily:              'Inter',
    colorScheme: const ColorScheme.dark(
      primary:     AppColors.yellow,
      secondary:   AppColors.yellow,
      surface:     AppColors.card,   // ← era 'background', corregido a 'surface'
      onPrimary:   AppColors.black,
      onSecondary: AppColors.black,
      onSurface:   AppColors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.black,
      elevation:       0,
      centerTitle:     true,
      iconTheme:       IconThemeData(color: AppColors.white),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor:          Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.yellow,
        foregroundColor: AppColors.black,
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size(double.infinity, 54),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled:    true,
      fillColor: AppColors.card2,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.yellow, width: 1.5)),
      labelStyle: const TextStyle(color: AppColors.textSub),
      hintStyle:  const TextStyle(color: AppColors.textDim),
    ),
    dividerColor: AppColors.border,
  );
}