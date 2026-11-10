import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';
import 'home_screen.dart';

class NewsDetailScreen extends StatelessWidget {
  final News item;
  const NewsDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Image.asset(
                  item.image,
                  height: 320 + top,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: top + 8,
                  left: S.page,
                  right: S.page,
                  child: Row(
                    children: [
                      const BackBtn(bg: Colors.white),
                      const Spacer(),
                      RoundButton(
                        Icons.bookmark_border_rounded,
                        bg: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      RoundButton(Icons.ios_share_rounded, bg: Colors.white),
                    ],
                  ),
                ),
                const SheetLip(),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(S.page, 0, S.page, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Tag(item.category, color: C.navy, bg: C.navySoft),
                  const SizedBox(height: 12),
                  Text(item.title, style: T.h1),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Logo(size: 34),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'إعلام الجامعة',
                              style: T.h3.copyWith(fontSize: 13),
                            ),
                            Text(
                              '${item.date} • قراءة 3 دقائق',
                              style: T.small,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Hairline(),
                  const SizedBox(height: 16),
                  Text(item.body, style: T.body.copyWith(fontSize: 15)),
                  const SizedBox(height: 28),
                  Text('أخبار ذات صلة', style: T.h2),
                  for (final n in news.where((n) => n != item).take(2)) ...[
                    NewsRow(n),
                    const Hairline(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
