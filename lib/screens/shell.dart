import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import '../theme.dart';
import '../ui.dart';
import 'account_screen.dart';
import 'assistant_screen.dart';
import 'colleges_screen.dart';
import 'home_screen.dart';
import 'joy_screen.dart';
import 'news_screen.dart';

/// Whether the student is signed in (demo state, shared across screens).
final loggedIn = ValueNotifier<bool>(false);

/// Whether the student has completed first-time registration (demo state).
/// First Google sign-in → registration form; later sign-ins go straight in.
final registered = ValueNotifier<bool>(false);

/// Whether the student has set an optional username + password.
final hasPassword = ValueNotifier<bool>(false);

/// Lets any screen switch the bottom tab.
final currentTab = ValueNotifier<int>(0);

/// Whether the floating AI button is fully out. At rest it stays tucked at
/// the screen edge (out of the way); while the user scrolls it slides out,
/// and it tucks back shortly after scrolling stops.
final aiButtonShown = ValueNotifier<bool>(true);

class Shell extends StatefulWidget {
  final int initialTab;
  const Shell({super.key, this.initialTab = 0});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  Timer? _showAgain;

  static const _tabs = [
    (Icons.home_outlined, Icons.home_rounded, 'الرئيسية'),
    (Icons.school_outlined, Icons.school_rounded, 'الكليات'),
    (Icons.local_offer_outlined, Icons.local_offer_rounded, 'Joy'),
    (Icons.newspaper_outlined, Icons.newspaper_rounded, 'الأخبار'),
    (Icons.person_outline_rounded, Icons.person_rounded, 'حسابي'),
  ];

  @override
  void initState() {
    super.initState();
    currentTab.value = widget.initialTab;
    // Show it fully on launch so people notice it, then tuck it to the side.
    aiButtonShown.value = true;
    _tuckLater(const Duration(milliseconds: 2500));
  }

  void _tuckLater(Duration d) {
    _showAgain?.cancel();
    _showAgain = Timer(d, () => aiButtonShown.value = false);
  }

  @override
  void dispose() {
    _showAgain?.cancel();
    super.dispose();
  }

  /// Moving (scrolling) → the AI button slides out from the side.
  /// Stopped → it tucks back to the side 1.5 s later.
  bool _onScroll(ScrollNotification n) {
    if (n.metrics.axis != Axis.vertical) return false;
    if (n is UserScrollNotification && n.direction != ScrollDirection.idle) {
      _showAgain?.cancel();
      aiButtonShown.value = true;
    }
    if (n is ScrollEndNotification) {
      _tuckLater(const Duration(milliseconds: 1500));
    }
    return false;
  }

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
          floatingActionButton: const HelpChatButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: IndexedStack(
              index: tab,
              children: const [
                HomeScreen(),
                CollegesScreen(),
                JoyScreen(),
                NewsScreen(),
                AccountScreen(),
              ],
            ),
          ),
          bottomNavigationBar: _BottomBar(
            tabs: [for (final i in visible) (i, _tabs[i])],
            current: tab,
          ),
        );
      },
    );
  }
}

/// Classic white bottom bar with labels; the active icon sits in a soft pill
/// and gives a small bounce when selected.
class _BottomBar extends StatelessWidget {
  final List<(int, (IconData, IconData, String))> tabs;
  final int current;
  const _BottomBar({required this.tabs, required this.current});

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: C.line)),
    ),
    child: SafeArea(
      top: false,
      child: SizedBox(
        height: 68,
        child: Row(
          children: [
            for (final (i, (icon, active, label)) in tabs)
              Expanded(
                child: InkWell(
                  onTap: () => currentTab.value = i,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        padding: EdgeInsets.symmetric(
                          horizontal: i == current ? 18 : 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: i == current ? C.navySoft : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AnimatedScale(
                          scale: i == current ? 1.12 : 1,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.elasticOut,
                          child: Icon(
                            i == current ? active : icon,
                            size: 23,
                            color: i == current ? C.navy : C.muted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: T.small.copyWith(
                          fontSize: 11.5,
                          color: i == current ? C.navy : C.muted,
                          fontWeight: i == current
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                        child: Text(label),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

/// Floating 3D AI button.
/// • Glossy sphere look (radial highlight, rim light, layered shadows)
/// • Idle: gentle float up/down + slowly turning sparkle
/// • Slightly see-through so content behind is still visible
/// • At rest it is tucked at the screen edge (a sliver stays visible to tap);
///   while scrolling it slides out, then tucks back
class HelpChatButton extends StatefulWidget {
  const HelpChatButton({super.key});
  @override
  State<HelpChatButton> createState() => _HelpChatButtonState();
}

class _HelpChatButtonState extends State<HelpChatButton>
    with TickerProviderStateMixin {
  late final _idle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat(reverse: true);
  late final _spin = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();
  bool _pressed = false;

  @override
  void dispose() {
    _idle.dispose();
    _spin.dispose();
    super.dispose();
  }

  void _open() {
    aiButtonShown.value = true;
    go(context, const AssistantScreen());
  }

  @override
  Widget build(BuildContext context) {
    // In RTL the FAB sits on the left, so "away" means sliding left.
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return ValueListenableBuilder<bool>(
      valueListenable: aiButtonShown,
      builder: (_, shown, child) => AnimatedSlide(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
        offset: shown ? Offset.zero : Offset(rtl ? -.78 : .78, 0),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: shown ? .94 : .6,
          child: child,
        ),
      ),
      child: Tooltip(
        message: 'المساعد الذكي',
        child: Semantics(
          button: true,
          label: 'المساعد الذكي',
          child: GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) {
              setState(() => _pressed = false);
              _open();
            },
            child: AnimatedBuilder(
              animation: _idle,
              builder: (_, child) {
                final t = Curves.easeInOut.transform(_idle.value);
                return Transform.translate(
                  offset: Offset(0, -4 * t), // gentle float
                  child: AnimatedScale(
                    scale: _pressed ? .9 : 1,
                    duration: const Duration(milliseconds: 120),
                    child: _Sphere(lift: t, spin: _spin),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Sphere extends StatelessWidget {
  final double lift; // 0..1, used to breathe the shadow
  final Animation<double> spin;
  const _Sphere({required this.lift, required this.spin});

  @override
  Widget build(BuildContext context) {
    const size = 58.0;
    return SizedBox(
      width: size + 8,
      height: size + 14,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // soft ground shadow that shrinks as the button floats up
          Positioned(
            bottom: 0,
            child: Container(
              width: size * (.75 - .15 * lift),
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: C.navy.withValues(alpha: .35 - .12 * lift),
                    blurRadius: 12,
                  ),
                ],
              ),
            ),
          ),
          // the sphere
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                center: Alignment(-.35, -.45),
                radius: .95,
                colors: [Color(0xFF8EA4F2), Color(0xFF3553C4), C.navyDeep],
                stops: [0, .55, 1],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: .35),
                width: 1.2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x401E3A8A),
                  blurRadius: 14,
                  offset: Offset(0, 8),
                ),
                BoxShadow(
                  color: Color(0x261E3A8A),
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // glossy highlight
                Positioned(
                  top: 7,
                  left: 12,
                  child: Container(
                    width: 22,
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: .7),
                          Colors.white.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
                // slowly turning sparkle
                AnimatedBuilder(
                  animation: spin,
                  builder: (_, _) => Transform.rotate(
                    angle: spin.value * 2 * math.pi,
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // online dot
          Positioned(
            top: 3,
            right: 6,
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
    );
  }
}
