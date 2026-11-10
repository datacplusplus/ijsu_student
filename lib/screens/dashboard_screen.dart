import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'offer_qr_screen.dart';

class DashboardScreen extends StatelessWidget {
  final ValueChanged<int> onOpenTab;
  const DashboardScreen({super.key, required this.onOpenTab});

  @override
  Widget build(BuildContext context) {
    const s = demoStudent;
    const b = demoBalance;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          // ---------- Greeting ----------
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.goldSoft,
                child: Text(s.name.characters.first,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF9A7420))),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('صباح الخير 👋',
                        style:
                            TextStyle(color: AppColors.muted, fontSize: 14)),
                    Text('أحمد علي',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              _RoundIcon(Icons.notifications_none_rounded, badge: true),
            ],
          ),
          const SizedBox(height: 20),

          // ---------- Mini ID card ----------
          _MiniIdCard(onTap: () => onOpenTab(3)),
          const SizedBox(height: 16),

          // ---------- Stats ----------
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.trending_up_rounded,
                  label: 'المعدل',
                  value: '${s.gpa}',
                  color: AppColors.green,
                  soft: AppColors.greenSoft,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.event_available_rounded,
                  label: 'الحضور',
                  value: '${s.attendance}%',
                  color: AppColors.purple,
                  soft: AppColors.purpleSoft,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ---------- Balance summary ----------
          SoftCard(
            onTap: () => onOpenTab(1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const IconTile(Icons.account_balance_wallet_rounded,
                        size: 44),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('المتبقي من الأقساط',
                              style: TextStyle(
                                  color: AppColors.muted, fontSize: 13)),
                          Text(formatIqd(b.remaining),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    const Pill('قسط قادم',
                        icon: Icons.schedule_rounded,
                        color: AppColors.red,
                        background: AppColors.redSoft),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: b.progress,
                    minHeight: 9,
                    backgroundColor: AppColors.iconTile,
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                    'تم دفع ${(b.progress * 100).round()}% من ${formatIqd(b.totalFees)}',
                    style: const TextStyle(
                        color: AppColors.muted, fontSize: 12.5)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ---------- Quick actions ----------
          const SectionTitle('خدماتي'),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _QuickAction(Icons.calendar_month_rounded, 'الجدول'),
              _QuickAction(Icons.grading_rounded, 'الدرجات'),
              _QuickAction(Icons.assignment_rounded, 'الامتحانات'),
              _QuickAction(Icons.description_rounded, 'الطلبات'),
            ],
          ),
          const SizedBox(height: 24),

          // ---------- Joy teaser ----------
          SectionTitle('عروض Joy',
              action: 'عرض الكل', onAction: () => onOpenTab(2)),
          const SizedBox(height: 10),
          _JoyBanner(offer: demoOffers.first),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final bool badge;
  const _RoundIcon(this.icon, {this.badge = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.line),
          ),
          child: Icon(icon, color: AppColors.navy),
        ),
        if (badge)
          Positioned(
            top: 12,
            right: 14,
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: AppColors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}

class _MiniIdCard extends StatelessWidget {
  final VoidCallback onTap;
  const _MiniIdCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    const s = demoStudent;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          child: CustomPaint(
            painter: PatternPainter(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const UniLogo(size: 36),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text('هوية طالب • IJSU بغداد',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                      Pill(s.status,
                          icon: Icons.circle,
                          color: const Color(0xFF7CE0B0),
                          background: Colors.white.withValues(alpha: 0.12)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(s.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w800)),
                  Text('${s.college} • ${s.department}',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13.5)),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('رقم الطالب',
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 12)),
                          Text(s.id,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const Spacer(),
                      const Text('عرض الهوية',
                          style: TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w700)),
                      const Icon(Icons.chevron_left_rounded,
                          color: AppColors.gold),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color color, soft;
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.soft,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconTile(icon, color: color, background: soft, size: 44),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      const TextStyle(color: AppColors.muted, fontSize: 13)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const _QuickAction(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.line),
          ),
          child: Icon(icon, color: AppColors.navy, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      ],
    );
  }
}

class _JoyBanner extends StatelessWidget {
  final Offer offer;
  const _JoyBanner({required this.offer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => OfferQrScreen(offer: offer))),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFE3B95A), AppColors.gold],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(offer.shop,
                      style: const TextStyle(
                          color: AppColors.navy,
                          fontSize: 17,
                          fontWeight: FontWeight.w800)),
                  Text(offer.description,
                      style: TextStyle(
                          color: AppColors.navy.withValues(alpha: 0.75),
                          fontSize: 13)),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.qr_code_2_rounded,
                            color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text('استخدم الآن',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text('${offer.discount}%',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        height: 1,
                        fontWeight: FontWeight.w900)),
                const Text('خصم',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
