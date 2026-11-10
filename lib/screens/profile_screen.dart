import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'login_screen.dart';

/// Digital student ID + personal / academic details.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const s = demoStudent;
    return Scaffold(
      appBar: AppBar(
        title: const Text('هويتي الجامعية',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // ---------- Digital ID ----------
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              decoration: const BoxDecoration(gradient: AppColors.heroGradient),
              child: Stack(
                children: [
                  Positioned(
                    top: -60,
                    left: -40,
                    child: _Bubble(180),
                  ),
                  Positioned(
                    bottom: -70,
                    right: 120,
                    child: _Bubble(160),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const UniLogo(size: 40),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('جامعة الإمام جعفر الصادق (ع)',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800)),
                                  Text('هوية طالب • بغداد',
                                      style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            Pill(s.status,
                                icon: Icons.circle,
                                color: const Color(0xFF7CE0B0),
                                background:
                                    Colors.white.withValues(alpha: 0.12)),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Container(
                              width: 74,
                              height: 74,
                              decoration: BoxDecoration(
                                color: AppColors.goldSoft,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              alignment: Alignment.center,
                              child: Text(s.name.characters.first,
                                  style: const TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF9A7420))),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.name,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          height: 1.3,
                                          fontWeight: FontWeight.w800)),
                                  Text('${s.college} • ${s.department}',
                                      style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12.5)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('رقم الطالب',
                                    style: TextStyle(
                                        color: Colors.white60, fontSize: 12)),
                                Text(s.id,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.w900)),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(Icons.qr_code_2_rounded,
                                  color: AppColors.navy, size: 32),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ---------- Chips ----------
          Row(
            children: [
              _InfoChip('المرحلة', s.stage, AppColors.navy, AppColors.iconTile),
              const SizedBox(width: 10),
              _InfoChip('الدراسة', s.studyType, AppColors.green,
                  AppColors.greenSoft),
              const SizedBox(width: 10),
              _InfoChip('النظام', s.system, AppColors.purple,
                  AppColors.purpleSoft),
            ],
          ),
          const SizedBox(height: 22),

          const SectionTitle('البيانات الأكاديمية'),
          const SizedBox(height: 12),
          SoftCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Column(children: [
              _Row('الفرع', s.branch),
              _Row('الكلية', s.college),
              _Row('القسم', s.department),
              _Row('سنة القبول', s.admissionYear, last: true),
            ]),
          ),
          const SizedBox(height: 22),

          const SectionTitle('معلومات التواصل'),
          const SizedBox(height: 12),
          SoftCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Column(children: [
              _Row('البريد الجامعي', ltr(s.email)),
              _Row('الهاتف', ltr(s.phone), last: true),
            ]),
          ),
          const SizedBox(height: 22),

          OutlinedButton.icon(
            onPressed: () => Navigator.of(context, rootNavigator: true)
                .pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('تسجيل الخروج'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.red,
              backgroundColor: Colors.white,
              minimumSize: const Size.fromHeight(54),
              side: const BorderSide(color: AppColors.redSoft),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final double size;
  const _Bubble(this.size);
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.06),
        ),
      );
}

class _InfoChip extends StatelessWidget {
  final String label, value;
  final Color color, soft;
  const _InfoChip(this.label, this.value, this.color, this.soft);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: soft,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      color: color.withValues(alpha: 0.7), fontSize: 12)),
              Text(value,
                  style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      );
}

class _Row extends StatelessWidget {
  final String label, value;
  final bool last;
  const _Row(this.label, this.value, {this.last = false});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: last
              ? null
              : const Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: [
            Text(label, style: const TextStyle(color: AppColors.muted)),
            const Spacer(),
            Flexible(
              child: Text(value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
}
