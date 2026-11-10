import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'student_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure = true;
  bool _remember = true;

  void _login() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const StudentShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------- Navy header ----------
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(40)),
              child: Container(
                width: double.infinity,
                decoration:
                    const BoxDecoration(gradient: AppColors.heroGradient),
                child: CustomPaint(
                  painter: PatternPainter(),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 36, 24, 48),
                      child: Column(
                        children: const [
                          UniLogo(size: 104),
                          SizedBox(height: 22),
                          Text('بوابة الطالب',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800)),
                          SizedBox(height: 4),
                          Text('سجّل دخولك لعرض بياناتك ورصيدك وعروضك',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ---------- Form ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle('تسجيل الدخول'),
                  const SizedBox(height: 20),
                  const _Label('الرقم الجامعي'),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'مثال: ${ltr('2026-0148')}',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _Label('كلمة المرور'),
                  TextField(
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: _remember,
                        activeColor: AppColors.navy,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        onChanged: (v) => setState(() => _remember = v!),
                      ),
                      const Text('تذكرني'),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text('نسيت كلمة المرور؟',
                            style: TextStyle(
                                color: AppColors.navy,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _login,
                    child: const Text('دخول'),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: _login,
                    icon: const Icon(Icons.fingerprint_rounded, size: 26),
                    label: const Text('الدخول بالبصمة'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.navy,
                      minimumSize: const Size.fromHeight(56),
                      side: const BorderSide(color: AppColors.line),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: 'ليس لديك حساب؟ ',
                        style: const TextStyle(color: AppColors.muted),
                        children: [
                          TextSpan(
                            text: 'راجع شعبة التسجيل',
                            style: TextStyle(
                                color: AppColors.gold.withValues(alpha: 1),
                                fontWeight: FontWeight.w700),
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
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8, right: 4),
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      );
}
