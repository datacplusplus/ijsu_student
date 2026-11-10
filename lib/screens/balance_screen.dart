import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const b = balance;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            const PageHeader('الرصيد والأقساط'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: S.page),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'المبلغ المتبقي',
                    style: T.body.copyWith(color: C.muted),
                  ),
                  Text(
                    iqd(b.remaining),
                    style: T.display.copyWith(fontSize: 34),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: b.progress,
                      minHeight: 10,
                      backgroundColor: C.surface,
                      color: C.navy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'تم دفع ${(b.progress * 100).round()}% من القسط السنوي',
                    style: T.small,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: Stat(
                          'المدفوع',
                          iqd(b.paid),
                          color: C.green,
                          bg: C.greenSoft,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Stat(
                          'الإجمالي',
                          iqd(b.total),
                          color: C.navy,
                          bg: C.navySoft,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Next due
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(S.r),
                      border: Border.all(color: C.line, width: 1.2),
                    ),
                    child: Row(
                      children: [
                        const IconBox(
                          Icons.event_outlined,
                          color: C.red,
                          bg: C.redSoft,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'القسط القادم • ${iqd(b.nextAmount)}',
                                style: T.h3,
                              ),
                              Text(
                                'يستحق في ${b.nextDate}',
                                style: T.small.copyWith(color: C.red),
                              ),
                            ],
                          ),
                        ),
                        FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(76, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text('ادفع'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('سجل الدفعات', style: T.h2),
                  const SizedBox(height: 4),
                  for (final p in payments)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: C.line)),
                      ),
                      child: Row(
                        children: [
                          IconBox(
                            p.paid
                                ? Icons.check_rounded
                                : Icons.schedule_rounded,
                            color: p.paid ? C.green : C.amber,
                            bg: p.paid ? C.greenSoft : C.amberSoft,
                            size: 42,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.title, style: T.h3),
                                Text(p.date, style: T.small),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                iqd(p.amount),
                                style: T.h3.copyWith(fontSize: 14),
                              ),
                              Text(
                                p.paid ? 'مدفوع' : 'غير مدفوع',
                                style: T.small.copyWith(
                                  color: p.paid ? C.green : C.amber,
                                  fontWeight: FontWeight.w700,
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
          ],
        ),
      ),
    );
  }
}
