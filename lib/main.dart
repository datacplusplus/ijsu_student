import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'mock_data.dart';
import 'screens/login_screen.dart';
import 'screens/offer_qr_screen.dart';
import 'screens/student_shell.dart';
import 'theme.dart';

void main() => runApp(const IjsuStudentApp());

/// On the web preview, `?screen=home|balance|joy|profile|qr` opens a screen
/// directly (used by the design gallery page). Phones always start at login.
Widget _startScreen() {
  if (!kIsWeb) return const LoginScreen();
  return switch (Uri.base.queryParameters['screen']) {
    'home' => const StudentShell(initialIndex: 0),
    'balance' => const StudentShell(initialIndex: 1),
    'joy' => const StudentShell(initialIndex: 2),
    'profile' => const StudentShell(initialIndex: 3),
    'qr' => OfferQrScreen(offer: demoOffers.first),
    _ => const LoginScreen(),
  };
}

class IjsuStudentApp extends StatelessWidget {
  const IjsuStudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IJSU Student',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: _startScreen(),
      // On wide screens (web preview), show the app in a phone-width frame.
      builder: (context, child) => ColoredBox(
        color: const Color(0xFFE6E3DA),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: child,
          ),
        ),
      ),
    );
  }
}
