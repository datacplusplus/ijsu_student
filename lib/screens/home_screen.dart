import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';
import 'about_screen.dart';
import 'assistant_screen.dart';
import 'contact_screen.dart';
import 'news_detail_screen.dart';
import 'notifications_screen.dart';
import 'shell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _slide = 0;

  static const _slides = [
    (
      '$img/hero_graduate.jpg',
      'منارة العلم والمعرفة',
      'ابدأ رحلتك الجامعية معنا',
    ),
    ('$img/library.jpg', 'مكتبة الجامعة', 'آلاف المصادر بين يديك'),
    ('$img/news_honor.jpg', 'تكريم الطلبة الأوائل', 'نحتفي بتفوق طلبتنا'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 28),
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(S.page, 10, S.page, 14),
            child: Row(
              children: [
                const Logo(size: 44),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'جامعة الإمام جعفر الصادق',
                        style: T.h3.copyWith(fontSize: 14.5),
                      ),
                      Row(
                        children: [
                          Text(
                            'فرع بغداد',
                            style: T.small.copyWith(
                              color: C.gold,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: C.gold,
                          ),
                        ],
                      ),
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
          ),

          // ── Hero slider ──
          SizedBox(
            height: 210,
            child: PageView.builder(
              controller: PageController(viewportFraction: .9),
              padEnds: true,
              itemCount: _slides.length,
              onPageChanged: (i) => setState(() => _slide = i),
              itemBuilder: (_, i) {
                final (src, title, sub) = _slides[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: PhotoCard(
                    src: src,
                    height: 210,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sub,
                          style: T.small.copyWith(
                            color: C.gold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(title, style: T.h1.copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _slide ? 22 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == _slide ? C.navy : C.line,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Quick access ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: S.page),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Quick(
                  Icons.school_outlined,
                  'الكليات',
                  C.navy,
                  C.navySoft,
                  () => currentTab.value = 1,
                ),
                _Quick(
                  Icons.auto_awesome_outlined,
                  'المساعد',
                  C.purple,
                  C.purpleSoft,
                  () => go(context, const AssistantScreen()),
                ),
                _Quick(
                  Icons.account_balance_outlined,
                  'عن الجامعة',
                  C.green,
                  C.greenSoft,
                  () => go(context, const AboutScreen()),
                ),
                _Quick(
                  Icons.call_outlined,
                  'اتصل بنا',
                  C.amber,
                  C.amberSoft,
                  () => go(context, const ContactScreen()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),

          // ── Student portal card ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: S.page),
            child: ValueListenableBuilder<bool>(
              valueListenable: loggedIn,
              builder: (_, isIn, _) =>
                  isIn ? const _StudentSummary() : const _LoginPrompt(),
            ),
          ),
          const SizedBox(height: 28),

          // ── Explore colleges (horizontal) ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: S.page),
            child: Section(
              'اكتشف الكليات',
              action: 'الكل',
              onAction: () => currentTab.value = 1,
            ),
          ),
          SizedBox(
            height: 170,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: S.page),
              itemCount: colleges.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final c = colleges[i];
                return SizedBox(
                  width: 230,
                  child: PhotoCard(
                    src: c.image,
                    height: 170,
                    onTap: () => currentTab.value = 1,
                    badge: Tag('${c.departments.length} أقسام'),
                    child: Text(
                      c.name,
                      style: T.h3.copyWith(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 28),

          // ── Latest news ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: S.page),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Section(
                  'آخر الأخبار',
                  action: 'عرض الكل',
                  onAction: () => currentTab.value = 3,
                ),
                GestureDetector(
                  onTap: () => go(context, NewsDetailScreen(item: news[0])),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Photo(news[0].image, height: 190, width: double.infinity),
                      const SizedBox(height: 12),
                      Text(news[0].category, style: T.label),
                      Text(news[0].title, style: T.h2),
                      const SizedBox(height: 4),
                      Text(news[0].date, style: T.small),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                for (final n in news.sublist(1, 3)) ...[
                  const Hairline(),
                  NewsRow(n),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),

          // ── Upcoming events (horizontal) ──
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: S.page),
            child: Section('فعاليات قادمة'),
          ),
          SizedBox(
            height: 232,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: S.page),
              itemCount: events.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _EventCard(events[i]),
            ),
          ),
          const SizedBox(height: 26),

          // ── Stats ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: S.page),
            child: Row(
              children: const [
                Expanded(
                  child: Stat('كليات', '+10', color: C.navy, bg: C.navySoft),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Stat('طالب', '+50K', color: C.green, bg: C.greenSoft),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Stat(
                    'نسبة النجاح',
                    '98%',
                    color: C.purple,
                    bg: C.purpleSoft,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // ── AI assistant banner ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: S.page),
            child: GestureDetector(
              onTap: () => go(context, const AssistantScreen()),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: C.goldSoft,
                  borderRadius: BorderRadius.circular(S.rLg),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('عندك سؤال عن القبول؟', style: T.h3),
                          Text(
                            'اسأل المساعد الذكي واحصل على إجابة فورية',
                            style: T.small.copyWith(color: C.ink2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: C.ink,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: C.gold,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Quick extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color, bg;
  final VoidCallback onTap;
  const _Quick(this.icon, this.label, this.color, this.bg, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        IconBox(icon, color: color, bg: bg, size: 62),
        const SizedBox(height: 8),
        Text(
          label,
          style: T.small.copyWith(color: C.ink, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

class _EventCard extends StatelessWidget {
  final Event e;
  const _EventCard(this.e);
  @override
  Widget build(BuildContext context) => Container(
    width: 210,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(S.r),
      border: Border.all(color: C.line, width: 1.2),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Photo(e.image, height: 130, width: 210, radius: S.r),
            PositionedDirectional(
              top: 10,
              start: 10,
              child: Container(
                width: 48,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      e.day,
                      style: T.h2.copyWith(height: 1.1, color: C.navy),
                    ),
                    Text(
                      e.month,
                      style: T.small.copyWith(fontSize: 10, color: C.ink2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: T.h3.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: C.muted,
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      e.place,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: T.small,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: C.navy,
      borderRadius: BorderRadius.circular(S.rLg),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('بوابة الطالب', style: T.h2.copyWith(color: Colors.white)),
              const SizedBox(height: 2),
              Text(
                'بياناتك، رصيدك، وخصومات Joy في مكان واحد',
                style: T.small.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => currentTab.value = 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'تسجيل الدخول',
                    style: T.h3.copyWith(color: C.navy, fontSize: 13.5),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Icon(Icons.badge_outlined, color: C.gold, size: 36),
        ),
      ],
    ),
  );
}

class _StudentSummary extends StatelessWidget {
  const _StudentSummary();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('أهلاً ${student.first} 👋', style: T.h2),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: Stat(
              'المعدل',
              '${student.gpa}',
              color: C.green,
              bg: C.greenSoft,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Stat(
              'الحضور',
              '${student.attendance}%',
              color: C.purple,
              bg: C.purpleSoft,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      RowCard(
        onTap: () => currentTab.value = 4,
        leading: const IconBox(
          Icons.account_balance_wallet_outlined,
          color: C.red,
          bg: C.redSoft,
        ),
        title: 'المتبقي ${iqd(balance.remaining)}',
        subtitle: 'القسط القادم ${balance.nextDate}',
      ),
    ],
  );
}

/// News list row (thumbnail + category + title + date).
class NewsRow extends StatelessWidget {
  final News n;
  const NewsRow(this.n, {super.key});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => go(context, NewsDetailScreen(item: n)),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(n.category, style: T.label.copyWith(fontSize: 11.5)),
                Text(
                  n.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: T.h3.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(n.date, style: T.small),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Photo(n.image, width: 92, height: 92, radius: 16),
        ],
      ),
    ),
  );
}
