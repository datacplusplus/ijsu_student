import 'package:flutter/material.dart';
import '../theme.dart';
import 'home_screen.dart';
import 'colleges_screen.dart';
import 'joy_screen.dart';
import 'news_screen.dart';
import 'account_screen.dart';

/// Whether the student is signed in (demo state, shared across screens).
final loggedIn = ValueNotifier<bool>(false);

/// Whether the student has completed first-time registration (demo state).
/// First Google sign-in → registration form; later sign-ins go straight in.
final registered = ValueNotifier<bool>(false);

/// Whether the student has set an optional username + password.
final hasPassword = ValueNotifier<bool>(false);

/// Lets any screen switch the bottom tab.
final currentTab = ValueNotifier<int>(0);

class Shell extends StatelessWidget {
  final int initialTab;
  Shell({super.key, this.initialTab = 0}) {
    currentTab.value = initialTab;
  }

  static const _tabs = [
    (Icons.home_outlined, Icons.home_rounded, 'الرئيسية'),
    (Icons.school_outlined, Icons.school_rounded, 'الكليات'),
    (Icons.local_offer_outlined, Icons.local_offer_rounded, 'Joy'),
    (Icons.newspaper_outlined, Icons.newspaper_rounded, 'الأخبار'),
    (Icons.person_outline_rounded, Icons.person_rounded, 'حسابي'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([currentTab, loggedIn]),
      builder: (context, _) {
        final isIn = loggedIn.value;
        // Joy (index 2) is only for signed-in students: hidden from the bar
        // when signed out, and a request for it shows the login tab instead.
        final tab = (!isIn && currentTab.value == 2) ? 4 : currentTab.value;
        final visible = [0, 1, if (isIn) 2, 3, 4];
        return Scaffold(
          body: IndexedStack(
            index: tab,
            children: const [
              HomeScreen(),
              CollegesScreen(),
              JoyScreen(),
              NewsScreen(),
              AccountScreen(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: C.line)),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 68,
                child: Row(
                  children: visible.map((i) {
                    final (icon, active, label) = _tabs[i];
                    final sel = i == tab;
                    return Expanded(
                      child: InkWell(
                        onTap: () => currentTab.value = i,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: sel ? C.navySoft : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                sel ? active : icon,
                                size: 23,
                                color: sel ? C.navy : C.muted,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              label,
                              style: T.small.copyWith(
                                fontSize: 11.5,
                                color: sel ? C.navy : C.muted,
                                fontWeight: sel
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
