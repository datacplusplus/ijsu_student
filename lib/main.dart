import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'data.dart';
import 'screens/about_screen.dart';
import 'screens/assistant_screen.dart';
import 'screens/balance_screen.dart';
import 'screens/branch_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/department_screen.dart';
import 'screens/news_detail_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/offer_qr_screen.dart';
import 'screens/shell.dart';
import 'screens/student_id_screen.dart';
import 'theme.dart';

void main() => runApp(const IjsuApp());

/// On the web preview, `?screen=...` opens a screen directly (used by the
/// design gallery). Phones always start at the branch picker.
Widget _start() {
  if (!kIsWeb) return const BranchScreen();
  final q = Uri.base.queryParameters;
  if (q['student'] == '1') loggedIn.value = true;
  return switch (q['screen']) {
    'home' => Shell(initialTab: 0),
    'colleges' => Shell(initialTab: 1),
    'joy' => Shell(initialTab: 2),
    'news' => Shell(initialTab: 3),
    'account' => Shell(initialTab: 4),
    'department' => DepartmentScreen(
      college: colleges[0],
      dept: colleges[0].departments[0],
    ),
    'article' => NewsDetailScreen(item: news[0]),
    'about' => const AboutScreen(),
    'contact' => const ContactScreen(),
    'assistant' => const AssistantScreen(),
    'notifications' => const NotificationsScreen(),
    'id' => const StudentIdScreen(),
    'balance' => const BalanceScreen(),
    'qr' => OfferQrScreen(offer: offers[0]),
    _ => const BranchScreen(),
  };
}

class IjsuApp extends StatelessWidget {
  const IjsuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IJSU',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: _start(),
      // On wide screens (web preview), show the app in a phone-width frame.
      builder: (context, child) => ColoredBox(
        color: const Color(0xFFF0F1F5),
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
