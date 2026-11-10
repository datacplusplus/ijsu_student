import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// IJSU design system — clean white, editorial, pastel accents.
class C {
  // Brand
  static const navy = Color(0xFF1E3A8A);
  static const navyDeep = Color(0xFF14275E);
  static const navySoft = Color(0xFFEAF0FF);
  static const gold = Color(0xFFD4A23C);
  static const goldSoft = Color(0xFFFFF5DC);

  // Neutrals
  static const bg = Colors.white;
  static const surface = Color(0xFFF4F6FA);
  static const line = Color(0xFFEDEFF4);
  static const ink = Color(0xFF0B1220);
  static const ink2 = Color(0xFF475069);
  static const muted = Color(0xFF8A93A6);

  // Pastel accents
  static const green = Color(0xFF12A150);
  static const greenSoft = Color(0xFFE6F6EC);
  static const purple = navy; // decorative accents folded into brand navy
  static const purpleSoft = navySoft;
  static const amber = Color(0xFFB7791F);
  static const amberSoft = Color(0xFFFFF4DB);
  static const red = Color(0xFFE5484D);
  static const redSoft = Color(0xFFFDECEC);
  static const teal = navy;
  static const tealSoft = navySoft;
}

/// Spacing & radius tokens.
class S {
  static const page = 20.0;
  static const r = 20.0;
  static const rLg = 28.0;
}

/// Text styles.
class T {
  static TextStyle get display => GoogleFonts.ibmPlexSansArabic(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: C.ink,
    height: 1.35,
  );
  static TextStyle get h1 => GoogleFonts.ibmPlexSansArabic(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: C.ink,
    height: 1.4,
  );
  static TextStyle get h2 => GoogleFonts.ibmPlexSansArabic(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: C.ink,
    height: 1.45,
  );
  static TextStyle get h3 => GoogleFonts.ibmPlexSansArabic(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: C.ink,
    height: 1.55,
  );
  static TextStyle get body => GoogleFonts.ibmPlexSansArabic(
    fontSize: 14.5,
    fontWeight: FontWeight.w400,
    color: C.ink2,
    height: 1.75,
  );
  static TextStyle get small => GoogleFonts.ibmPlexSansArabic(
    fontSize: 12.5,
    fontWeight: FontWeight.w400,
    color: C.muted,
    height: 1.5,
  );
  static TextStyle get label => GoogleFonts.ibmPlexSansArabic(
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: C.navy,
  );
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: C.navy,
      primary: C.navy,
      secondary: C.gold,
      surface: C.bg,
    ),
    scaffoldBackgroundColor: C.bg,
    splashFactory: InkSparkle.splashFactory,
  );
  return base.copyWith(
    textTheme: GoogleFonts.ibmPlexSansArabicTextTheme(
      base.textTheme,
    ).apply(bodyColor: C.ink, displayColor: C.ink),
    appBarTheme: AppBarTheme(
      backgroundColor: C.bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      foregroundColor: C.ink,
      titleTextStyle: T.h2,
    ),
    dividerTheme: const DividerThemeData(color: C.line, space: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: C.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: C.navy, width: 1.4),
      ),
      hintStyle: GoogleFonts.ibmPlexSansArabic(color: C.muted, fontSize: 14),
      prefixIconColor: C.muted,
      suffixIconColor: C.muted,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: C.navy,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: GoogleFonts.ibmPlexSansArabic(
          fontSize: 15.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: C.ink,
        minimumSize: const Size.fromHeight(56),
        side: const BorderSide(color: C.line, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: GoogleFonts.ibmPlexSansArabic(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
