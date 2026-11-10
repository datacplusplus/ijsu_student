import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'offer_qr_screen.dart';

/// "Joy" — student discounts from partner shops.
class JoyScreen extends StatefulWidget {
  const JoyScreen({super.key});

  @override
  State<JoyScreen> createState() => _JoyScreenState();
}

class _JoyScreenState extends State<JoyScreen> {
  int _cat = 0;

  @override
  Widget build(BuildContext context) {
    final cat = offerCategories[_cat];
    final offers =
        _cat == 0 ? demoOffers : demoOffers.where((o) => o.category == cat);
    final featured = demoOffers.firstWhere((o) => o.featured);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            sliver: SliverList.list(
              children: [
                // ---------- Header ----------
                Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Joy ✨',
                            style: TextStyle(
                                fontSize: 30,
                                height: 1.1,
                                fontWeight: FontWeight.w900,
                                color: AppColors.navy)),
                        Text('خصومات حصرية لطلبة الجامعة',
                            style: TextStyle(
                                color: AppColors.muted, fontSize: 14)),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.goldSoft,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Column(
                        children: [
                          Text('وفّرت',
                              style: TextStyle(
                                  fontSize: 11.5, color: Color(0xFF9A7420))),
                          Text('42,500',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF9A7420))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ---------- Search ----------
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'ابحث عن متجر أو عرض...',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: 18),

                // ---------- Featured ----------
                _FeaturedOffer(featured),
                const SizedBox(height: 18),
              ],
            ),
          ),

          // ---------- Categories ----------
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: offerCategories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final sel = i == _cat;
                  return GestureDetector(
                    onTap: () => setState(() => _cat = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: sel ? AppColors.navy : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            color: sel ? AppColors.navy : AppColors.line),
                      ),
                      child: Text(offerCategories[i],
                          style: TextStyle(
                              color: sel ? Colors.white : AppColors.ink,
                              fontWeight: FontWeight.w700)),
                    ),
                  );
                },
              ),
            ),
          ),

          // ---------- List ----------
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            sliver: SliverList.separated(
              itemCount: offers.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _OfferCard(offers.elementAt(i)),
            ),
          ),
        ],
      ),
    );
  }
}

void _openQr(BuildContext context, Offer o) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (_) => OfferQrScreen(offer: o)));

class _FeaturedOffer extends StatelessWidget {
  final Offer o;
  const _FeaturedOffer(this.o);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openQr(context, o),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          child: CustomPaint(
            painter: PatternPainter(),
            child: Stack(
              children: [
                PositionedDirectional(
                  end: -30,
                  bottom: -40,
                  child: Icon(o.icon,
                      size: 170, color: Colors.white.withValues(alpha: 0.07)),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Pill('⭐  عرض الأسبوع',
                          color: AppColors.navy, background: AppColors.gold),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${o.discount}%',
                              style: const TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 52,
                                  height: 1,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(width: 8),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Text('خصم',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(o.shop,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w800)),
                      Text(o.description,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13.5)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 9),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.qr_code_2_rounded,
                                color: AppColors.navy, size: 20),
                            SizedBox(width: 6),
                            Text('عرض رمز الخصم',
                                style: TextStyle(
                                    color: AppColors.navy,
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final Offer o;
  const _OfferCard(this.o);

  @override
  Widget build(BuildContext context) {
    final usedUp = o.usesLeft == 0;
    return SoftCard(
      padding: const EdgeInsets.all(14),
      onTap: usedUp ? null : () => _openQr(context, o),
      child: Row(
        children: [
          IconTile(o.icon, color: o.color, background: o.soft, size: 60),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(o.shop,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800)),
                Text(o.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.muted, fontSize: 13)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded,
                        size: 14, color: AppColors.muted),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text('حتى ${o.validUntil}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.muted, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 64,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: o.soft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Text('${o.discount}%',
                    style: TextStyle(
                        color: o.color,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
                Text('خصم',
                    style: TextStyle(
                        color: o.color,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
