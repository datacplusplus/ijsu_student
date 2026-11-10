import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// IJSU brand palette — matches the existing app (navy + gold on cream).
class AppColors {
  static const navy = Color(0xFF1B2F6B);
  static const navyLight = Color(0xFF2D4C93);
  static const gold = Color(0xFFC9A24A);
  static const goldSoft = Color(0xFFF6EBD0);
  static const bg = Color(0xFFF7F5F0);
  static const card = Colors.white;
  static const ink = Color(0xFF151B33);
  static const muted = Color(0xFF7A8099);
  static const line = Color(0xFFECE9E1);
  static const iconTile = Color(0xFFEDF0F7);
  static const green = Color(0xFF1F9D6B);
  static const greenSoft = Color(0xFFE3F5EC);
  static const red = Color(0xFFD64545);
  static const redSoft = Color(0xFFFBE7E7);
  static const purple = Color(0xFF6A4BC4);
  static const purpleSoft = Color(0xFFEEE9FB);

  static const heroGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [navy, navyLight],
  );
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navy,
        primary: AppColors.navy,
        secondary: AppColors.gold,
        surface: AppColors.bg,
      ),
      scaffoldBackgroundColor: AppColors.bg,
    );
    return base.copyWith(
      textTheme: GoogleFonts.cairoTextTheme(base.textTheme).apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: AppColors.ink,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.4),
        ),
        hintStyle: const TextStyle(color: AppColors.muted),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(58),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.cairo(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
