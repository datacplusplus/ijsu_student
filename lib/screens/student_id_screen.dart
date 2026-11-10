import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';

/// Digital student ID + details.
class StudentIdScreen extends StatelessWidget {
  const StudentIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const s = student;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            PageHeader(
              'هويتي الجامعية',
              action: RoundButton(Icons.edit_outlined),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: S.page),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // ID card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(S.rLg),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [C.navy, C.navyDeep],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -50,
                            left: -40,
                            child: _Circle(170, .07),
                          ),
                          Positioned(
                            bottom: -60,
                            right: 110,
                            child: _Circle(150, .05),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Logo(size: 38),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'جامعة الإمام جعفر الصادق (ع)',
                                            style: T.h3.copyWith(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            'هوية طالب • بغداد',
                                            style: T.small.copyWith(
                                              color: Colors.white60,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tag(
                                      s.status,
                                      icon: Icons.circle,
                                      color: const Color(0xFF7CE0B0),
                                      bg: Colors.white.withValues(alpha: .12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 22),
                                Row(
                                  children: [
                                    Container(
                                      width: 72,
                                      height: 72,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: C.goldSoft,
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      child: Text(
                                        s.first.characters.first,
                                        style: T.display.copyWith(
                                          color: C.amber,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            s.name,
                                            style: T.h2.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '${s.college} • ${s.department}',
                                            style: T.small.copyWith(
                                              color: Colors.white70,
                                            ),
                                          ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'رقم الطالب',
                                          style: T.small.copyWith(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        Text(
                                          s.id,
                                          style: T.display.copyWith(
                                            color: Colors.white,
                                            fontSize: 26,
                                            letterSpacing: 2,
                                          ),
                                        ),
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
                                      child: const Icon(
                                        Icons.qr_code_2_rounded,
                                        color: C.navy,
                                        size: 32,
                                      ),
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
                  Row(
                    children: [
                      Expanded(
                        child: Stat(
                          'المرحلة',
                          s.stage,
                          color: C.navy,
                          bg: C.navySoft,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Stat(
                          'الدراسة',
                          s.studyType,
                          color: C.navy,
                          bg: C.greenSoft,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Stat(
                          'النظام',
                          s.system,
                          color: C.purple,
                          bg: C.purpleSoft,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Text('البيانات الأكاديمية', style: T.h2),
                  const SizedBox(height: 4),
                  _Info('الفرع', s.branch),
                  _Info('الكلية', s.college),
                  _Info('القسم', s.department),
                  _Info('سنة القبول', s.admissionYear),
                  const SizedBox(height: 22),
                  Text('معلومات التواصل', style: T.h2),
                  const SizedBox(height: 4),
                  _Info('البريد الجامعي', ltr(s.email)),
                  _Info('الهاتف', ltr(s.phone)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final double size, alpha;
  const _Circle(this.size, this.alpha);
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: alpha),
    ),
  );
}

class _Info extends StatelessWidget {
  final String label, value;
  const _Info(this.label, this.value);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: C.line)),
    ),
    child: Row(
      children: [
        Text(label, style: T.body.copyWith(color: C.muted)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: T.h3.copyWith(fontSize: 14),
          ),
        ),
      ],
    ),
  );
}
