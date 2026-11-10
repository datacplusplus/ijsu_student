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
                  height: 380 + top,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Dark fade so the headline on the photo stays readable
                Positioned.fill(
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x550B1220),
                          Colors.transparent,
                          Color(0xE60B1220),
                        ],
                        stops: [0, .35, 1],
                      ),
                    ),
                  ),
                ),
                // Category · time · headline on the photo
                Positioned(
                  left: S.page,
                  right: S.page,
                  bottom: 48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Tag(item.category),
                          const SizedBox(width: 10),
                          Text(
                            item.date,
                            style: T.small.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.title,
                        style: T.h1.copyWith(color: Colors.white, height: 1.5),
                      ),
                    ],
                  ),
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
