import 'package:flutter/material.dart';
import '../theme.dart';
import '../ui.dart';
import 'shell.dart';

/// Optional username + password, so the student can sign in without Google.
/// Shown once after registration (skippable) and later from Settings.
class CredentialsScreen extends StatefulWidget {
  final bool afterRegistration;
  const CredentialsScreen({super.key, this.afterRegistration = false});
  @override
  State<CredentialsScreen> createState() => _CredentialsScreenState();
}

class _CredentialsScreenState extends State<CredentialsScreen> {
  final _pass = TextEditingController(text: 'Ijsu2026!');
  bool _hide = true;

  int get _strength {
    final p = _pass.text;
    var s = 0;
    if (p.length >= 8) s++;
    if (RegExp(r'[A-Z]').hasMatch(p) && RegExp(r'[a-z]').hasMatch(p)) s++;
    if (RegExp(r'\d').hasMatch(p)) s++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(p)) s++;
    return s;
  }

  void _finish({required bool saved}) {
    if (saved) hasPassword.value = true;
    if (widget.afterRegistration) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = _strength;
    const labels = ['ضعيفة جداً', 'ضعيفة', 'متوسطة', 'جيدة', 'قوية'];
    const colors = [C.red, C.red, C.amber, C.green, C.green];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (widget.afterRegistration)
              Padding(
                padding: const EdgeInsets.fromLTRB(S.page, 8, S.page, 0),
                child: Row(
                  children: [
                    const SizedBox(width: 44, height: 44),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _finish(saved: false),
                      child: Text('تخطي', style: T.h3.copyWith(color: C.muted)),
                    ),
                  ],
                ),
              )
            else
              const PageHeader('اسم المستخدم وكلمة المرور'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(S.page, 8, S.page, 20),
                children: [
                  const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: IconBox(
                      Icons.key_rounded,
                      color: C.purple,
                      bg: C.purpleSoft,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('أضف كلمة مرور لحسابك', style: T.display),
                  const SizedBox(height: 4),
                  Text(
                    'اختياري — تستطيع دائماً الدخول عبر Google. أضف اسم مستخدم وكلمة مرور إن أردت الدخول بدونه.',
                    style: T.body,
                  ),
                  const SizedBox(height: 8),
                  const FieldLabel('اسم المستخدم'),
                  TextFormField(
                    initialValue: 'ahmed.ali',
                    textDirection: TextDirection.ltr,
                    style: T.h3.copyWith(fontSize: 14),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.alternate_email_rounded),
                      suffixIcon: Icon(
                        Icons.check_circle_rounded,
                        color: C.green,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, right: 4),
                    child: Text(
                      'اسم المستخدم متاح',
                      style: T.small.copyWith(color: C.green),
                    ),
                  ),
                  const FieldLabel('كلمة المرور'),
                  TextField(
                    controller: _pass,
                    obscureText: _hide,
                    textDirection: TextDirection.ltr,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hide
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () => setState(() => _hide = !_hide),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      for (var i = 0; i < 4; i++) ...[
                        if (i > 0) const SizedBox(width: 6),
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 5,
                            decoration: BoxDecoration(
                              color: i < s ? colors[s] : C.line,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(width: 10),
                      Text(
                        labels[s],
                        style: T.small.copyWith(
                          color: colors[s],
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  for (final (ok, t) in [
                    (_pass.text.length >= 8, '8 أحرف على الأقل'),
                    (RegExp(r'\d').hasMatch(_pass.text), 'رقم واحد على الأقل'),
                    (
                      RegExp(r'[^A-Za-z0-9]').hasMatch(_pass.text),
                      'رمز خاص مثل ! أو @',
                    ),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Icon(
                            ok
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            size: 18,
                            color: ok ? C.green : C.muted,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            t,
                            style: T.small.copyWith(
                              color: ok ? C.ink2 : C.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const FieldLabel('تأكيد كلمة المرور'),
                  TextFormField(
                    initialValue: 'Ijsu2026!',
                    obscureText: true,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(S.page, 8, S.page, 14),
              child: Column(
                children: [
                  FilledButton(
                    onPressed: s >= 3 ? () => _finish(saved: true) : null,
                    child: const Text('حفظ ومتابعة'),
                  ),
                  if (widget.afterRegistration) ...[
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () => _finish(saved: false),
                      child: Text(
                        'لاحقاً — يمكنك إضافتها من الإعدادات',
                        style: T.small.copyWith(color: C.ink2),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Success screen after registration.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(S.page),
        child: Column(
          children: [
            const Spacer(),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: .6, end: 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              builder: (_, v, child) => Transform.scale(scale: v, child: child),
              child: Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  color: C.greenSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: C.green,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 26),
            Text(
              'تم إنشاء حسابك 🎉',
              style: T.display,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'ستطابق الجامعة بياناتك مع سجلات القبول. يمكنك الآن تصفح بياناتك ورصيدك وعروض Joy.',
              style: T.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            ValueListenableBuilder<bool>(
              valueListenable: hasPassword,
              builder: (_, has, _) => Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(S.r),
                ),
                child: Row(
                  children: [
                    const GoogleLogo(size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        has
                            ? 'تسجيل الدخول: Google أو اسم المستخدم وكلمة المرور'
                            : 'تسجيل الدخول: عبر Google',
                        style: T.h3.copyWith(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                registered.value = true;
                loggedIn.value = true;
                Navigator.of(context).popUntil((r) => r.isFirst);
              },
              child: const Text('الذهاب إلى حسابي'),
            ),
          ],
        ),
      ),
    ),
  );
}
