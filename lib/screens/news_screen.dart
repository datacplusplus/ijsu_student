import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';
import 'home_screen.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int _cat = 0;

  @override
  Widget build(BuildContext context) {
    final list = _cat == 0
        ? news
        : news.where((n) => n.category == newsCategories[_cat]).toList();
    final featured = list.isNotEmpty ? list.first : null;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const BigTitle('أخبار الجامعة', overline: 'فرع بغداد'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: S.page),
            child: SearchField('ابحث في الأخبار...'),
          ),
          const SizedBox(height: 14),
          Chips(
            items: newsCategories,
            selected: _cat,
            onSelect: (i) => setState(() => _cat = i),
          ),
          const SizedBox(height: 18),
          if (featured == null)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Text(
                'لا توجد أخبار في هذا التصنيف بعد',
                textAlign: TextAlign.center,
                style: T.body,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: S.page),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => go(context, NewsDetailScreen(item: featured)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Photo(
                              featured.image,
                              height: 210,
                              width: double.infinity,
                            ),
                            const PositionedDirectional(
                              top: 12,
                              end: 12,
                              child: Tag(
                                'الأكثر قراءة',
                                icon: Icons.trending_up_rounded,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          featured.title,
                          style: T.h1.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Logo(size: 20),
                            const SizedBox(width: 6),
                            Text(
                              '${featured.category}  •  ${featured.date}',
                              style: T.small,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (list.length > 1) ...[
                    const SizedBox(height: 26),
                    Text('الأحدث', style: T.h2),
                    const SizedBox(height: 4),
                    for (final n in list.skip(1)) ...[
                      NewsRow(n),
                      const Hairline(),
                    ],
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
