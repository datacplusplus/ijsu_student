import 'dart:async';
import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';
import 'offer_qr_screen.dart';

/// Joy — partner shop discounts for students (signed-in only).
/// Lively by design: points & level, story-style categories, a flash deal
/// with a live countdown, nearby offers and what's trending.
class JoyScreen extends StatefulWidget {
  const JoyScreen({super.key});
  @override
  State<JoyScreen> createState() => _JoyScreenState();
}

class _JoyScreenState extends State<JoyScreen> {
  int _cat = 0;

  @override
  Widget build(BuildContext context) {
    final cat = offerCategories[_cat].$1;
    final list = _cat == 0
        ? offers
        : offers.where((o) => o.category == cat).toList();
    final trending = [...list]..sort((a, b) => b.usedBy.compareTo(a.usedBy));

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(S.page, 12, S.page, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('خصومات حصرية لطلبة الجامعة', style: T.small),
                      Row(
                        children: [
                          Text('Joy', style: T.display.copyWith(fontSize: 30)),
                          const SizedBox(width: 6),
                          const Text('✨', style: TextStyle(fontSize: 22)),
                        ],
                      ),
                    ],
                  ),
                ),
                const RoundButton(Icons.search_rounded),
                const SizedBox(width: 8),
                const RoundButton(Icons.history_rounded),
              ],
            ),
          ),

          // ── Points & level ──
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: S.page),
            child: _PointsCard(),
          ),
          const SizedBox(height: 22),

          // ── Story-style categories ──
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: S.page),
              itemCount: offerCategories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (_, i) => _CategoryBubble(
                cat: offerCategories[i],
                selected: i == _cat,
                onTap: () => setState(() => _cat = i),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // ── Flash deal with live countdown ──
          if (_cat == 0 || flashDeal.category == cat) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: S.page),
              child: _FlashDeal(),
            ),
            const SizedBox(height: 26),
          ],

          // ── Near you ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: S.page),
            child: Section('قريب منك 📍', action: 'الخريطة', onAction: () {}),
          ),
          SizedBox(
            height: 196,
            child: list.isEmpty
                ? Center(child: Text('لا توجد عروض هنا بعد', style: T.body))
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: S.page),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => _NearCard(list[i]),
                  ),
          ),
          const SizedBox(height: 24),

          // ── Trending ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: S.page),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Section('الأكثر رواجاً هذا الأسبوع 🔥'),
                for (var i = 0; i < trending.length; i++) ...[
                  _TrendRow(trending[i], rank: i + 1),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _open(BuildContext context, Offer o) =>
    go(context, OfferQrScreen(offer: o));

// ─────────────────────────── Points card ───────────────────────────
class _PointsCard extends StatelessWidget {
  const _PointsCard();
  @override
  Widget build(BuildContext context) {
    const p = joyPoints / joyNextLevel;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [C.navy, Color(0xFF2B4BB0)],
        ),
        borderRadius: BorderRadius.circular(S.rLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFE6E8EE), Color(0xFFB8BDCB)],
                  ),
                ),
                child: const Icon(
                  Icons.military_tech_rounded,
                  color: C.navy,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المستوى الفضي',
                      style: T.h3.copyWith(color: Colors.white),
                    ),
                    Text(
                      'وفّرت 42,500 د.ع هذا الفصل',
                      style: T.small.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$joyPoints',
                    style: T.h1.copyWith(color: C.gold, height: 1.1),
                  ),
                  Text('نقطة', style: T.small.copyWith(color: Colors.white70)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: p),
              duration: const Duration(milliseconds: 1100),
              curve: Curves.easeOutCubic,
              builder: (_, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 8,
                backgroundColor: Colors.white.withValues(alpha: .15),
                color: C.gold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${joyNextLevel - joyPoints} نقطة للوصول إلى المستوى الذهبي 🏆',
                  style: T.small.copyWith(color: Colors.white),
                ),
              ),
              // earned badges
              for (final e in ['☕', '📚', '🍔'])
                Container(
                  margin: const EdgeInsetsDirectional.only(start: 4),
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .14),
                    shape: BoxShape.circle,
                  ),
                  child: Text(e, style: const TextStyle(fontSize: 13)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Category bubble ───────────────────────────
class _CategoryBubble extends StatelessWidget {
  final (String, IconData, bool) cat;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryBubble({
    required this.cat,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (name, icon, hasNew) = cat;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // story ring when the category has new offers
              gradient: hasNew
                  ? const SweepGradient(
                      colors: [C.gold, Color(0xFFE8833A), C.navy, C.gold],
                    )
                  : null,
              border: hasNew
                  ? null
                  : Border.all(color: selected ? C.navy : C.line, width: 1.5),
            ),
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: selected ? C.navy : C.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: selected ? Colors.white : C.ink2,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: T.small.copyWith(
              fontSize: 11.5,
              color: selected ? C.navy : C.ink2,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Flash deal ───────────────────────────
class _FlashDeal extends StatefulWidget {
  const _FlashDeal();
  @override
  State<_FlashDeal> createState() => _FlashDealState();
}

class _FlashDealState extends State<_FlashDeal> {
  late Timer _t;
  late Duration _left = _untilMidnight();

  static Duration _untilMidnight() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1).difference(now);
  }

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _left = _untilMidnight()),
    );
  }

  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final o = flashDeal;
    final h = _left.inHours, m = _left.inMinutes % 60, s = _left.inSeconds % 60;
    return GestureDetector(
      onTap: () => _open(context, o),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: o.soft,
          borderRadius: BorderRadius.circular(S.rLg),
          border: Border.all(color: o.color.withValues(alpha: .35), width: 1.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Tag('⚡ عرض سريع اليوم', color: Colors.white, bg: o.color),
                const Spacer(),
                Text('ينتهي خلال', style: T.small.copyWith(color: C.ink2)),
                const SizedBox(width: 6),
                // live countdown (LTR so it reads hh:mm:ss)
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      _TimeBox(_two(h)),
                      _colon(),
                      _TimeBox(_two(m)),
                      _colon(),
                      _TimeBox(_two(s)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(o.icon, color: o.color, size: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(o.shop, style: T.h2),
                      Text(
                        o.description,
                        style: T.small.copyWith(color: C.ink2),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${o.discount}%',
                  style: T.display.copyWith(color: o.color, fontSize: 32),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: flashClaimed,
                minHeight: 7,
                backgroundColor: Colors.white,
                color: o.color,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  'تم استخدام ${(flashClaimed * 100).round()}% من العرض',
                  style: T.small.copyWith(color: C.ink2),
                ),
                const Spacer(),
                Text(
                  'استخدم الآن ←',
                  style: T.h3.copyWith(color: o.color, fontSize: 13.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _colon() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: Text(':', style: T.h3.copyWith(color: C.ink)),
  );
}

class _TimeBox extends StatelessWidget {
  final String v;
  const _TimeBox(this.v);
  @override
  Widget build(BuildContext context) => Container(
    width: 30,
    padding: const EdgeInsets.symmetric(vertical: 4),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: C.ink,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(v, style: T.h3.copyWith(color: Colors.white, fontSize: 13.5)),
  );
}

// ─────────────────────────── Near you card ───────────────────────────
class _NearCard extends StatelessWidget {
  final Offer o;
  const _NearCard(this.o);
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => _open(context, o),
    child: Container(
      width: 172,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(S.r),
        border: Border.all(color: C.line, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // coloured top with big icon + discount
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: o.soft,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(S.r),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Center(child: Icon(o.icon, size: 44, color: o.color)),
                PositionedDirectional(
                  top: 10,
                  start: 10,
                  child: Tag(
                    'خصم ${o.discount}%',
                    color: Colors.white,
                    bg: o.color,
                  ),
                ),
                if (o.isNew)
                  const PositionedDirectional(
                    top: 10,
                    end: 10,
                    child: Tag('جديد', color: C.ink, bg: Colors.white),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  o.shop,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: T.h3.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.near_me_outlined,
                      size: 13,
                      color: C.muted,
                    ),
                    const SizedBox(width: 3),
                    Text(o.distance, style: T.small.copyWith(fontSize: 11.5)),
                    const Spacer(),
                    Text(o.category, style: T.small.copyWith(fontSize: 11.5)),
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

// ─────────────────────────── Trending row ───────────────────────────
class _TrendRow extends StatelessWidget {
  final Offer o;
  final int rank;
  const _TrendRow(this.o, {required this.rank});
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(S.r),
      side: const BorderSide(color: C.line, width: 1.2),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(S.r),
      onTap: () => _open(context, o),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              child: Text(
                '$rank',
                style: T.h2.copyWith(color: rank <= 3 ? C.gold : C.muted),
              ),
            ),
            IconBox(o.icon, color: o.color, bg: o.soft, size: 52),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          o.shop,
                          overflow: TextOverflow.ellipsis,
                          style: T.h3,
                        ),
                      ),
                      if (o.isNew) ...[
                        const SizedBox(width: 6),
                        const Tag('جديد', color: C.green, bg: C.greenSoft),
                      ],
                    ],
                  ),
                  Text(
                    o.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: T.small.copyWith(color: C.ink2),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        size: 14,
                        color: Color(0xFFE8833A),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'استخدمه ${o.usedBy} طالب',
                        style: T.small.copyWith(fontSize: 11.5),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.near_me_outlined,
                        size: 13,
                        color: C.muted,
                      ),
                      const SizedBox(width: 2),
                      Text(o.distance, style: T.small.copyWith(fontSize: 11.5)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 58,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: o.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '${o.discount}%',
                    style: T.h2.copyWith(color: Colors.white),
                  ),
                  Text(
                    'خصم',
                    style: T.small.copyWith(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
