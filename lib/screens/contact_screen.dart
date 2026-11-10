import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            const PageHeader('تواصل معنا'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: S.page),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('نحن هنا لمساعدتك', style: T.display),
                  const SizedBox(height: 4),
                  Text('تواصل مع الجامعة بالطريقة التي تناسبك.', style: T.body),
                  const SizedBox(height: 20),

                  // Primary actions
                  Row(
                    children: [
                      Expanded(
                        child: _Action(
                          Icons.call_outlined,
                          'اتصال',
                          C.green,
                          C.greenSoft,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Action(
                          Icons.chat_bubble_outline_rounded,
                          'واتساب',
                          C.teal,
                          C.tealSoft,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Action(
                          Icons.mail_outline_rounded,
                          'بريد',
                          C.navy,
                          C.navySoft,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  RowCard(
                    leading: const IconBox(Icons.phone_outlined),
                    title: 'الاستعلامات',
                    subtitle: ltr('0772 200 1188'),
                  ),
                  const SizedBox(height: 10),
                  RowCard(
                    leading: const IconBox(
                      Icons.support_agent_outlined,
                      color: C.purple,
                      bg: C.purpleSoft,
                    ),
                    title: 'شعبة التسجيل',
                    subtitle: ltr('0782 200 1188'),
                  ),
                  const SizedBox(height: 10),
                  const RowCard(
                    leading: IconBox(
                      Icons.location_on_outlined,
                      color: C.red,
                      bg: C.redSoft,
                    ),
                    title: 'الموقع',
                    subtitle: 'بغداد • الحارثية • عرض على الخريطة',
                  ),
                  const SizedBox(height: 26),

                  // Working hours
                  Text('ساعات العمل', style: T.h2),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: C.surface,
                      borderRadius: BorderRadius.circular(S.r),
                    ),
                    child: Column(
                      children: [
                        _Hours('السبت – الأربعاء', '8:00 ص – 4:00 م', true),
                        const SizedBox(height: 10),
                        _Hours('الخميس', '8:00 ص – 1:00 م', true),
                        const SizedBox(height: 10),
                        _Hours('الجمعة', 'مغلق', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),

                  // Social
                  Text('تابعنا', style: T.h2),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _Social(Icons.facebook_rounded, 'فيسبوك'),
                      _Social(Icons.send_outlined, 'تيليجرام'),
                      _Social(Icons.camera_alt_outlined, 'إنستغرام'),
                      _Social(Icons.work_outline_rounded, 'لينكدإن'),
                      _Social(Icons.language_rounded, 'الموقع'),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // FAQ
                  Text('الأسئلة الشائعة', style: T.h2),
                  const SizedBox(height: 8),
                  for (final (q, a) in faqs) _Faq(q, a),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color, bg;
  const _Action(this.icon, this.label, this.color, this.bg);
  @override
  Widget build(BuildContext context) => Material(
    color: bg,
    borderRadius: BorderRadius.circular(S.r),
    child: InkWell(
      borderRadius: BorderRadius.circular(S.r),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 6),
            Text(label, style: T.h3.copyWith(color: color, fontSize: 13)),
          ],
        ),
      ),
    ),
  );
}

class _Hours extends StatelessWidget {
  final String day, time;
  final bool open;
  const _Hours(this.day, this.time, this.open);
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: open ? C.green : C.red,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(child: Text(day, style: T.h3.copyWith(fontSize: 14))),
      Text(
        time,
        style: T.small.copyWith(
          color: open ? C.ink2 : C.red,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

class _Social extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Social(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: C.line, width: 1.2),
        ),
        child: Icon(icon, color: C.ink),
      ),
      const SizedBox(height: 6),
      Text(label, style: T.small.copyWith(fontSize: 11)),
    ],
  );
}

class _Faq extends StatelessWidget {
  final String q, a;
  const _Faq(this.q, this.a);
  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    child: Column(
      children: [
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(bottom: 14),
          iconColor: C.navy,
          collapsedIconColor: C.muted,
          title: Text(q, style: T.h3.copyWith(fontSize: 14)),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(a, style: T.body),
            ),
          ],
        ),
        const Hairline(),
      ],
    ),
  );
}
