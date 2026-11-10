import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _values = [
    (
      Icons.workspace_premium_outlined,
      'التميز',
      'نسعى لأعلى معايير الجودة',
      C.navy,
      C.navySoft,
    ),
    (
      Icons.verified_outlined,
      'النزاهة',
      'الصدق والشفافية في التعامل',
      C.navy,
      C.navySoft,
    ),
    (
      Icons.lightbulb_outline_rounded,
      'الابتكار',
      'نشجع التفكير الإبداعي',
      C.navy,
      C.navySoft,
    ),
    (
      Icons.diversity_3_outlined,
      'الشمولية',
      'بيئة تعليمية للجميع',
      C.navy,
      C.navySoft,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            const PageHeader('عن الجامعة'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: S.page),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  PhotoCard(
                    src: '$img/library.jpg',
                    height: 220,
                    child: Row(
                      children: [
                        const Logo(size: 46),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'جامعة الإمام جعفر الصادق (ع)',
                            style: T.h2.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(
                        child: Stat(
                          'تأسست',
                          '2004',
                          color: C.navy,
                          bg: C.navySoft,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Stat(
                          'فروع',
                          '8',
                          color: C.navy,
                          bg: C.greenSoft,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Stat(
                          'طلبة',
                          '+50K',
                          color: C.purple,
                          bg: C.purpleSoft,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Text('مهمتنا', style: T.h2),
                  const SizedBox(height: 6),
                  Text(
                    'في جامعة الإمام جعفر الصادق، مهمتنا هي سد الفجوة بين الطالب والتعليم الجيد. '
                    'نؤمن بأن كل طالب يستحق الحصول على أفضل فرصة تعليمية، بما يتناسب مع أهدافه '
                    'وطموحاته، من خلال التوجيه الشخصي والموارد الشاملة والتكنولوجيا الحديثة.',
                    style: T.body,
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: C.goldSoft,
                      borderRadius: BorderRadius.circular(S.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.format_quote_rounded,
                          color: C.gold,
                          size: 30,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'رؤيتنا: أن نكون جامعة رائدة في التعليم والبحث العلمي وخدمة المجتمع.',
                            style: T.h3.copyWith(height: 1.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text('قيمنا الأساسية', style: T.h2),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.15,
                    children: [
                      for (final (icon, title, sub, color, soft) in _values)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(S.r),
                            border: Border.all(color: C.line, width: 1.2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconBox(icon, color: color, bg: soft, size: 42),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title, style: T.h3),
                                  Text(sub, style: T.small),
                                ],
                              ),
                            ],
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
    );
  }
}
