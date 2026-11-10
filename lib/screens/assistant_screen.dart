import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';

/// AI assistant chat (UI only — replies are canned demo text).
class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});
  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final _msgs = <(bool, String)>[]; // (isUser, text)
  final _ctrl = TextEditingController();

  static const _hello =
      'أهلاً! أنا مساعد جامعة الإمام جعفر الصادق، هنا لأجيب عن أسئلتك حول القبول والأقسام والأقساط.';

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _msgs.add((true, text.trim()));
      _msgs.add((
        false,
        'سؤال ممتاز! تختلف معدلات القبول حسب القناة ونوع الدراسة. '
            'للعام 2026–2027 يمكنك مراجعة صفحة القسم أو التواصل مع شعبة التسجيل للتفاصيل الدقيقة.',
      ));
    });
    _ctrl.clear();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Soft glow background
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, .1),
                  radius: .9,
                  colors: [Color(0xFFE6EAFB), Colors.white],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header: back · assistant pill · reset
                Padding(
                  padding: const EdgeInsets.fromLTRB(S.page, 8, S.page, 8),
                  child: Row(
                    children: [
                      const BackBtn(bg: Colors.white),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: C.line),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const _Orb(size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'المساعد الذكي',
                              style: T.h3.copyWith(fontSize: 14),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: C.muted,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      RoundButton(
                        Icons.refresh_rounded,
                        bg: Colors.white,
                        onTap: () => setState(_msgs.clear),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(S.page, 16, S.page, 16),
                    children: [
                      const _Bubble(_hello, user: false),
                      for (final (user, text) in _msgs)
                        _Bubble(text, user: user),
                      if (_msgs.isEmpty) ...[
                        const SizedBox(height: 70),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 16,
                              color: C.ink2,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'جرّب أن تسأل',
                              style: T.h3.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        for (final q in assistantSuggestions)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Material(
                                color: Colors.white.withValues(alpha: .8),
                                shape: const StadiumBorder(
                                  side: BorderSide(color: C.line),
                                ),
                                child: InkWell(
                                  customBorder: const StadiumBorder(),
                                  onTap: () => _send(q),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 11,
                                    ),
                                    child: Text(
                                      q,
                                      textAlign: TextAlign.center,
                                      style: T.body.copyWith(
                                        fontSize: 13.5,
                                        color: C.navy,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),

                // Input pill: + · text · mic · send
                Padding(
                  padding: const EdgeInsets.fromLTRB(S.page, 6, S.page, 4),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: C.navy.withValues(alpha: .35),
                        width: 1.4,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x141E3A8A),
                          blurRadius: 20,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _Circle(Icons.add_rounded, onTap: () {}),
                        Expanded(
                          child: TextField(
                            controller: _ctrl,
                            onSubmitted: _send,
                            decoration: const InputDecoration(
                              hintText: 'كيف يمكن للمساعد مساعدتك؟',
                              filled: false,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                          ),
                        ),
                        _Circle(Icons.mic_none_rounded, onTap: () {}),
                        const SizedBox(width: 4),
                        _Circle(
                          Icons.arrow_upward_rounded,
                          filled: true,
                          onTap: () => _send(_ctrl.text),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 4),
                  child: Text.rich(
                    TextSpan(
                      text: 'قد يخطئ المساعد أحياناً. ',
                      style: T.small.copyWith(fontSize: 11.5),
                      children: [
                        TextSpan(
                          text: 'اعرف المزيد',
                          style: T.small.copyWith(
                            fontSize: 11.5,
                            color: C.navy,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Gradient orb used as the assistant's avatar.
class _Orb extends StatelessWidget {
  final double size;
  const _Orb({this.size = 32});
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4F6BD8), C.navy, C.gold],
        stops: [0, .6, 1],
      ),
    ),
  );
}

class _Bubble extends StatelessWidget {
  final String text;
  final bool user;
  const _Bubble(this.text, {required this.user});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      mainAxisAlignment: user ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!user) ...[const _Orb(), const SizedBox(width: 8)],
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            constraints: const BoxConstraints(maxWidth: 290),
            decoration: BoxDecoration(
              color: user ? C.ink : C.navy,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(user ? 20 : 6),
                topEnd: const Radius.circular(20),
                bottomStart: const Radius.circular(20),
                bottomEnd: Radius.circular(user ? 6 : 20),
              ),
            ),
            child: Text(
              text,
              style: T.body.copyWith(
                color: Colors.white,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _Circle extends StatelessWidget {
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;
  const _Circle(this.icon, {this.filled = false, required this.onTap});
  @override
  Widget build(BuildContext context) => Material(
    color: filled ? C.navy : C.surface,
    shape: const CircleBorder(),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Icon(icon, size: 21, color: filled ? Colors.white : C.ink2),
      ),
    ),
  );
}
