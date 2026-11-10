import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';
import 'about_screen.dart';
import 'balance_screen.dart';
import 'branch_screen.dart';
import 'contact_screen.dart';
import 'notifications_screen.dart';
import 'shell.dart';
import 'student_id_screen.dart';

/// "حسابي" tab: login when signed out, student hub when signed in.
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: loggedIn,
    builder: (_, isIn, _) => isIn ? const _Hub() : const LoginView(),
  );
}

// ───────────────────────── Login ─────────────────────────
class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _hide = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(S.page, 28, S.page, 24),
        children: [
          const Align(alignment: Alignment.centerRight, child: Logo(size: 60)),
          const SizedBox(height: 20),
          Text('تسجيل الدخول', style: T.display),
          const SizedBox(height: 4),
          Text(
            'ادخل إلى بوابة الطالب لعرض بياناتك ورصيدك وعروض Joy.',
            style: T.body,
          ),
          const SizedBox(height: 26),
          Text('الرقم الجامعي', style: T.h3.copyWith(fontSize: 13.5)),
          const SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'مثال: ${ltr('2026-0148')}',
              prefixIcon: const Icon(Icons.badge_outlined),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'كلمة المرور',
                  style: T.h3.copyWith(fontSize: 13.5),
                ),
              ),
              Text('نسيت كلمة المرور؟', style: T.label),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: _hide,
            decoration: InputDecoration(
              hintText: '••••••••',
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
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => loggedIn.value = true,
            child: const Text('دخول'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => loggedIn.value = true,
            icon: const Icon(Icons.fingerprint_rounded, size: 24),
            label: const Text('الدخول بالبصمة'),
          ),
          const SizedBox(height: 32),
          Text('عام', style: T.h3.copyWith(color: C.muted)),
          const SizedBox(height: 4),
          const _Settings(showLogout: false),
        ],
      ),
    );
  }
}

// ───────────────────────── Student hub ─────────────────────────
class _Hub extends StatelessWidget {
  const _Hub();

  @override
  Widget build(BuildContext context) {
    const s = student;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(S.page, 12, S.page, 24),
        children: [
          // Profile header
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: C.goldSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  s.first.characters.first,
                  style: T.h1.copyWith(color: C.amber),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.name, style: T.h2.copyWith(fontSize: 16.5)),
                    Text('${s.department} • ${ltr(s.id)}', style: T.small),
                  ],
                ),
              ),
              RoundButton(
                Icons.notifications_none_rounded,
                dot: true,
                onTap: () => go(context, const NotificationsScreen()),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Digital ID teaser
          GestureDetector(
            onTap: () => go(context, const StudentIdScreen()),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [C.navy, C.navyDeep],
                ),
                borderRadius: BorderRadius.circular(S.rLg),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'هويتي الجامعية',
                          style: T.small.copyWith(color: Colors.white70),
                        ),
                        Text(
                          s.id,
                          style: T.h1.copyWith(
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Tag(
                          s.status,
                          icon: Icons.circle,
                          color: const Color(0xFF7CE0B0),
                          bg: Colors.white.withValues(alpha: .12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.qr_code_2_rounded,
                      color: C.navy,
                      size: 34,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Quick tiles
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.6,
            children: [
              _Tile(
                Icons.account_balance_wallet_outlined,
                'الرصيد',
                iqd(balance.remaining),
                C.red,
                C.redSoft,
                () => go(context, const BalanceScreen()),
              ),
              _Tile(
                Icons.local_offer_outlined,
                'عروض Joy',
                '${offers.length} عروض متاحة',
                C.amber,
                C.amberSoft,
                () => currentTab.value = 2,
              ),
              _Tile(
                Icons.trending_up_rounded,
                'المعدل',
                '${s.gpa}',
                C.green,
                C.greenSoft,
                () {},
              ),
              _Tile(
                Icons.calendar_today_outlined,
                'الجدول',
                '3 محاضرات اليوم',
                C.purple,
                C.purpleSoft,
                () {},
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text('الإعدادات', style: T.h3.copyWith(color: C.muted)),
          const SizedBox(height: 4),
          const _Settings(showLogout: true),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title, value;
  final Color color, bg;
  final VoidCallback onTap;
  const _Tile(
    this.icon,
    this.title,
    this.value,
    this.color,
    this.bg,
    this.onTap,
  );
  @override
  Widget build(BuildContext context) => Material(
    color: bg,
    borderRadius: BorderRadius.circular(S.r),
    child: InkWell(
      borderRadius: BorderRadius.circular(S.r),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: T.h3.copyWith(fontSize: 14)),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: T.small.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// ───────────────────────── Settings list ─────────────────────────
class _Settings extends StatefulWidget {
  final bool showLogout;
  const _Settings({required this.showLogout});
  @override
  State<_Settings> createState() => _SettingsState();
}

class _SettingsState extends State<_Settings> {
  bool _ar = true;
  bool _notify = true;

  Widget _row(
    IconData icon,
    String title, {
    String? value,
    Widget? trailing,
    VoidCallback? onTap,
    Color color = C.ink,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: T.h3.copyWith(color: color, fontWeight: FontWeight.w500),
              ),
            ),
            if (value != null) Text(value, style: T.small),
            trailing ?? const Icon(Icons.chevron_left_rounded, color: C.muted),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(
          Icons.location_on_outlined,
          'الفرع',
          value: 'بغداد',
          onTap: () =>
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const BranchScreen()),
                (_) => false,
              ),
        ),
        const Hairline(),
        _row(
          Icons.translate_rounded,
          'اللغة',
          trailing: _LangSwitch(
            ar: _ar,
            onChanged: (v) => setState(() => _ar = v),
          ),
        ),
        const Hairline(),
        _row(
          Icons.notifications_none_rounded,
          'الإشعارات',
          trailing: Switch(
            value: _notify,
            activeThumbColor: Colors.white,
            activeTrackColor: C.navy,
            onChanged: (v) => setState(() => _notify = v),
          ),
        ),
        const Hairline(),
        _row(
          Icons.info_outline_rounded,
          'عن الجامعة',
          onTap: () => go(context, const AboutScreen()),
        ),
        const Hairline(),
        _row(
          Icons.headset_mic_outlined,
          'تواصل معنا',
          onTap: () => go(context, const ContactScreen()),
        ),
        if (widget.showLogout) ...[
          const Hairline(),
          _row(
            Icons.logout_rounded,
            'تسجيل الخروج',
            color: C.red,
            trailing: const SizedBox(),
            onTap: () => loggedIn.value = false,
          ),
        ],
      ],
    );
  }
}

class _LangSwitch extends StatelessWidget {
  final bool ar;
  final ValueChanged<bool> onChanged;
  const _LangSwitch({required this.ar, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    Widget seg(String t, bool sel, bool v) => GestureDetector(
      onTap: () => onChanged(v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: sel ? C.navy : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          t,
          style: T.small.copyWith(
            color: sel ? Colors.white : C.ink2,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [seg('ع', ar, true), seg('En', !ar, false)],
      ),
    );
  }
}
