import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../widgets.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const b = demoBalance;
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرصيد والأقساط',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // ---------- Big balance card ----------
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              decoration: const BoxDecoration(gradient: AppColors.heroGradient),
              child: CustomPaint(
                painter: PatternPainter(),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('المبلغ المتبقي',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(formatIqd(b.remaining),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 18),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: b.progress,
                          minHeight: 10,
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
                          color: AppColors.gold,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          _Figure('المدفوع', formatIqd(b.paid)),
                          Container(
                              width: 1,
                              height: 36,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              color: Colors.white24),
                          _Figure('الإجمالي السنوي', formatIqd(b.totalFees)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ---------- Next due ----------
          SoftCard(
            child: Row(
              children: [
                const IconTile(Icons.event_rounded,
                    color: AppColors.red, background: AppColors.redSoft),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('القسط القادم',
                          style: TextStyle(
                              color: AppColors.muted, fontSize: 13)),
                      Text(formatIqd(b.nextDueAmount),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800)),
                      Text('يستحق في ${b.nextDueDate}',
                          style: const TextStyle(
                              color: AppColors.red,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                      minimumSize: const Size(90, 46),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  child: const Text('ادفع'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),

          // ---------- History ----------
          const SectionTitle('سجل الدفعات'),
          const SizedBox(height: 12),
          SoftCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Column(
              children: [
                for (var i = 0; i < demoPayments.length; i++) ...[
                  _PaymentRow(demoPayments[i]),
                  if (i != demoPayments.length - 1)
                    const Divider(color: AppColors.line, height: 1),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  final String label, value;
  const _Figure(this.label, this.value);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white60, fontSize: 12.5)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800)),
        ],
      );
}

class _PaymentRow extends StatelessWidget {
  final Payment p;
  const _PaymentRow(this.p);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          IconTile(
            p.isPaid ? Icons.check_rounded : Icons.schedule_rounded,
            size: 42,
            color: p.isPaid ? AppColors.green : const Color(0xFFB7791F),
            background:
                p.isPaid ? AppColors.greenSoft : const Color(0xFFFDF3DE),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.title,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(p.date,
                    style: const TextStyle(
                        color: AppColors.muted, fontSize: 12.5)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(formatIqd(p.amount),
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              Text(p.isPaid ? 'مدفوع' : 'غير مدفوع',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: p.isPaid
                          ? AppColors.green
                          : const Color(0xFFB7791F))),
            ],
          ),
        ],
      ),
    );
  }
}
