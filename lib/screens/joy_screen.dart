import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';
import 'offer_qr_screen.dart';

/// Joy — partner shop discounts for students.
class JoyScreen extends StatefulWidget {
  const JoyScreen({super.key});
  @override
  State<JoyScreen> createState() => _JoyScreenState();
}

class _JoyScreenState extends State<JoyScreen> {
  int _cat = 0;

  @override
  Widget build(BuildContext context) {
    final list = _cat == 0
        ? offers
        : offers.where((o) => o.category == offerCategories[_cat]).toList();
    final top = offers.first;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          BigTitle(
            'Joy',
            overline: 'خصومات حصرية لطلبة الجامعة',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: C.greenSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'وفّرت',
                    style: T.small.copyWith(color: C.green, fontSize: 11),
                  ),
                  Text('42,500', style: T.h3.copyWith(color: C.green)),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: S.page),
            child: SearchField('ابحث عن متجر أو عرض...'),
          ),
          const SizedBox(height: 18),

          // Featured offer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: S.page),
            child: GestureDetector(
              onTap: () => go(context, OfferQrScreen(offer: top)),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: C.ink,
                  borderRadius: BorderRadius.circular(S.rLg),
                ),
                child: Stack(
                  children: [
                    PositionedDirectional(
                      end: -10,
                      bottom: -20,
                      child: Icon(
                        top.icon,
                        size: 130,
                        color: Colors.white.withValues(alpha: .06),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Tag(
                          'عرض الأسبوع',
                          icon: Icons.star_rounded,
                          color: C.ink,
                          bg: C.gold,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${top.discount}%',
                              style: T.display.copyWith(
                                color: C.gold,
                                fontSize: 48,
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                'خصم',
                                style: T.h2.copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          top.shop,
                          style: T.h2.copyWith(color: Colors.white),
                        ),
                        Text(
                          top.description,
                          style: T.small.copyWith(color: Colors.white60),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.qr_code_2_rounded,
                                size: 20,
                                color: C.ink,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'عرض رمز الخصم',
                                style: T.h3.copyWith(fontSize: 13.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Chips(
            items: offerCategories,
            selected: _cat,
            onSelect: (i) => setState(() => _cat = i),
          ),
          const SizedBox(height: 16),

          // Offers list
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: S.page),
            child: Column(
              children: [
                if (list.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text(
                      'لا توجد عروض في هذا التصنيف حالياً',
                      style: T.body,
                    ),
                  ),
                for (final o in list) ...[
                  _OfferCard(o),
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

class _OfferCard extends StatelessWidget {
  final Offer o;
  const _OfferCard(this.o);
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(S.r),
      side: const BorderSide(color: C.line, width: 1.2),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(S.r),
      onTap: () => go(context, OfferQrScreen(offer: o)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            IconBox(o.icon, color: o.color, bg: o.soft, size: 58),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(o.shop, style: T.h3),
                  Text(
                    o.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: T.small.copyWith(color: C.ink2),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'حتى ${o.validUntil} • ${o.usesLeft} استخدامات متبقية',
                    style: T.small.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: o.soft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '${o.discount}%',
                    style: T.h2.copyWith(
                      color: o.color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'خصم',
                    style: T.small.copyWith(
                      color: o.color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
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
