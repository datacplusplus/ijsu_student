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
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              'المساعد الذكي',
              action: RoundButton(
                Icons.refresh_rounded,
                onTap: () => setState(_msgs.clear),
              ),
            ),
            Expanded(
              child: _msgs.isEmpty ? _Welcome(onAsk: _send) : _Chat(_msgs),
            ),
            // Input
            Container(
              padding: const EdgeInsets.fromLTRB(S.page, 10, S.page, 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: C.line)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      onSubmitted: _send,
                      decoration: InputDecoration(
                        hintText: 'اكتب سؤالك...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.auto_awesome_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: C.navy,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => _send(_ctrl.text),
                      child: const SizedBox(
                        width: 52,
                        height: 52,
                        child: Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Welcome extends StatelessWidget {
  final ValueChanged<String> onAsk;
  const _Welcome({required this.onAsk});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(S.page, 24, S.page, 16),
    children: [
      Center(
        child: Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [C.purpleSoft, C.navySoft]),
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Icon(Icons.auto_awesome, color: C.purple, size: 38),
        ),
      ),
      const SizedBox(height: 18),
      Text(
        'كيف يمكنني مساعدتك اليوم؟',
        textAlign: TextAlign.center,
        style: T.h1,
      ),
      const SizedBox(height: 6),
      Text(
        'اسأل عن القبول، الأقسام، الأقساط أو أي شيء عن الجامعة',
        textAlign: TextAlign.center,
        style: T.body,
      ),
      const SizedBox(height: 28),
      Text('أسئلة مقترحة', style: T.h3.copyWith(color: C.muted)),
      const SizedBox(height: 10),
      for (final s in assistantSuggestions) ...[
        Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(S.r),
            side: const BorderSide(color: C.line, width: 1.2),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(S.r),
            onTap: () => onAsk(s),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(
                    Icons.north_west_rounded,
                    size: 18,
                    color: C.muted,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(s, style: T.h3.copyWith(fontSize: 13.5)),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    ],
  );
}

class _Chat extends StatelessWidget {
  final List<(bool, String)> msgs;
  const _Chat(this.msgs);
  @override
  Widget build(BuildContext context) => ListView.builder(
    padding: const EdgeInsets.all(S.page),
    itemCount: msgs.length,
    itemBuilder: (_, i) {
      final (user, text) = msgs[i];
      return Align(
        alignment: user ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
            color: user ? C.navy : C.surface,
            borderRadius: BorderRadiusDirectional.only(
              topStart: const Radius.circular(20),
              topEnd: const Radius.circular(20),
              bottomStart: Radius.circular(user ? 6 : 20),
              bottomEnd: Radius.circular(user ? 20 : 6),
            ),
          ),
          child: Text(
            text,
            style: T.body.copyWith(
              color: user ? Colors.white : C.ink,
              fontSize: 14,
            ),
          ),
        ),
      );
    },
  );
}
