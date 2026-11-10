import 'package:flutter/material.dart';
import '../theme.dart';
import 'home_screen.dart';
import 'colleges_screen.dart';
import 'joy_screen.dart';
import 'news_screen.dart';
import 'account_screen.dart';
import 'assistant_screen.dart';
import '../ui.dart';

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
          // The bar floats over the content; SafeArea in each tab keeps
          // content clear of it (Scaffold reports the bar as bottom padding).
          extendBody: true,
          // Floating help-chat button on every tab → AI assistant
          floatingActionButton: const HelpChatButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          bottomNavigationBar: SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 12),
            child: Center(
              heightFactor: 1,
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: C.ink,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x330B1220),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: visible.map((i) {
                    final (icon, active, label) = _tabs[i];
                    final sel = i == tab;
                    return Tooltip(
                      message: label,
                      child: Semantics(
                        label: label,
                        selected: sel,
                        button: true,
                        child: GestureDetector(
                          onTap: () => currentTab.value = i,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: EdgeInsets.symmetric(
                              horizontal: sel ? 16 : 12,
                            ),
                            height: 48,
                            decoration: BoxDecoration(
                              color: sel ? C.gold : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  sel ? active : icon,
                                  size: 22,
                                  color: sel ? C.ink : Colors.white70,
                                ),
                                // Active tab also shows its name
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 250),
                                  child: sel
                                      ? Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                start: 6,
                                              ),
                                          child: Text(
                                            label,
                                            style: T.h3.copyWith(
                                              fontSize: 13,
                                              color: C.ink,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
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

/// Floating help-chat bubble: gradient orb with a chat icon, gentle pulse
/// ring and a small "online" dot. Opens the AI assistant.
class HelpChatButton extends StatefulWidget {
  const HelpChatButton({super.key});
  @override
  State<HelpChatButton> createState() => _HelpChatButtonState();
}

class _HelpChatButtonState extends State<HelpChatButton>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // keep clear of the floating bottom capsule
      padding: const EdgeInsets.only(bottom: 4),
      child: Tooltip(
        message: 'المساعد الذكي',
        child: Semantics(
          button: true,
          label: 'المساعد الذكي',
          child: GestureDetector(
            onTap: () => go(context, const AssistantScreen()),
            child: SizedBox(
              width: 68,
              height: 68,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // pulse ring
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, _) => Container(
                      width: 56 + 12 * _pulse.value,
                      height: 56 + 12 * _pulse.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: C.navy.withValues(
                          alpha: .18 * (1 - _pulse.value),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF4F6BD8), C.navy],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x551E3A8A),
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 3),
                          child: Icon(
                            Icons.auto_awesome,
                            color: C.navy,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // online dot
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
