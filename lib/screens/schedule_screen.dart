import 'package:flutter/material.dart';
import '../theme.dart';
import '../ui.dart';

/// Weekly lecture schedule: week strip, weekly progress, day's lectures.
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _Lecture {
  final String time, end, subject, room, teacher;
  final bool done;
  const _Lecture(
    this.time,
    this.end,
    this.subject,
    this.room,
    this.teacher, {
    this.done = false,
  });
}

// Iraqi week: Saturday → Thursday. 10 Nov 2026 is a Tuesday.
const _days = [
  ('سبت', 7),
  ('أحد', 8),
  ('اثنين', 9),
  ('ثلاثاء', 10),
  ('أربعاء', 11),
  ('خميس', 12),
];
const _today = 3;

const _lectures = <int, List<_Lecture>>{
  0: [
    _Lecture(
      '8:30',
      '10:00',
      'مبادئ الإدارة',
      'قاعة 12',
      'أ.د. حسن كاظم',
      done: true,
    ),
    _Lecture(
      '10:30',
      '12:00',
      'الرياضيات',
      'قاعة 4',
      'م.د. سعاد جبار',
      done: true,
    ),
  ],
  1: [
    _Lecture(
      '9:00',
      '10:30',
      'الاقتصاد الجزئي',
      'قاعة 7',
      'م.د. زينب علي',
      done: true,
    ),
  ],
  2: [
    _Lecture(
      '8:30',
      '10:00',
      'الحاسوب',
      'مختبر 2',
      'م.م. علي جاسم',
      done: true,
    ),
    _Lecture(
      '10:30',
      '12:00',
      'اللغة الإنكليزية',
      'قاعة 3',
      'م. نور حيدر',
      done: true,
    ),
  ],
  3: [
    _Lecture(
      '8:30',
      '10:00',
      'مبادئ الإدارة',
      'قاعة 12',
      'أ.د. حسن كاظم',
      done: true,
    ),
    _Lecture('10:30', '12:00', 'الإحصاء', 'قاعة 9', 'م.د. كرار محمد'),
    _Lecture('12:30', '2:00', 'حقوق الإنسان', 'قاعة 5', 'م. مريم عباس'),
  ],
  4: [
    _Lecture('9:00', '10:30', 'الاقتصاد الجزئي', 'قاعة 7', 'م.د. زينب علي'),
    _Lecture('11:00', '12:30', 'الحاسوب', 'مختبر 2', 'م.م. علي جاسم'),
  ],
  5: [],
};

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _sel = _today;

  @override
  Widget build(BuildContext context) {
    final list = _lectures[_sel]!;
    final total = _lectures.values.fold<int>(0, (a, l) => a + l.length);
    final done = _lectures.values.fold<int>(
      0,
      (a, l) => a + l.where((x) => x.done).length,
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            PageHeader(
              'جدولي',
              action: RoundButton(Icons.notifications_none_rounded),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: S.page),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // ── Week strip + weekly progress ──
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: C.surface,
                      borderRadius: BorderRadius.circular(S.rLg),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('تشرين الثاني 2026', style: T.h3),
                            const Spacer(),
                            Text('الأسبوع 10', style: T.small),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            for (var i = 0; i < _days.length; i++)
                              Expanded(child: _day(i)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                          decoration: BoxDecoration(
                            color: C.navy,
                            borderRadius: BorderRadius.circular(S.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'تقدّم الأسبوع',
                                      style: T.h3.copyWith(color: Colors.white),
                                    ),
                                    Text(
                                      '$done من $total محاضرات • يومان متبقيان',
                                      style: T.small.copyWith(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _MiniRing(done / total),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Day's lectures ──
                  Row(
                    children: [
                      Text(
                        _sel == _today
                            ? 'محاضرات اليوم'
                            : 'محاضرات ${_days[_sel].$1}',
                        style: T.h2,
                      ),
                      const Spacer(),
                      Text('${list.length} محاضرات', style: T.small),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (list.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(28),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(S.r),
                        border: Border.all(color: C.line, width: 1.2),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.weekend_outlined,
                            color: C.muted,
                            size: 34,
                          ),
                          const SizedBox(height: 8),
                          Text('لا توجد محاضرات — يوم راحة', style: T.body),
                        ],
                      ),
                    ),
                  for (var i = 0; i < list.length; i++)
                    _LectureTile(
                      list[i],
                      now:
                          _sel == _today &&
                          !list[i].done &&
                          (i == 0 || list[i - 1].done),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _day(int i) {
    final (name, date) = _days[i];
    final sel = i == _sel;
    final has = _lectures[i]!.isNotEmpty;
    return GestureDetector(
      onTap: () => setState(() => _sel = i),
      child: Column(
        children: [
          Text(name, style: T.small.copyWith(fontSize: 11)),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: sel ? C.navy : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: i == _today && !sel ? C.navy : Colors.transparent,
                width: 1.4,
              ),
            ),
            child: Text(
              '$date',
              style: T.h3.copyWith(color: sel ? Colors.white : C.ink),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: has ? (sel ? C.navy : C.gold) : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniRing extends StatelessWidget {
  final double v;
  const _MiniRing(this.v);
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 54,
    height: 54,
    child: Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.expand(
          child: CircularProgressIndicator(
            value: v,
            strokeWidth: 5,
            strokeCap: StrokeCap.round,
            backgroundColor: Colors.white.withValues(alpha: .18),
            color: C.gold,
          ),
        ),
        Text(
          '${(v * 100).round()}%',
          style: T.small.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _LectureTile extends StatelessWidget {
  final _Lecture l;
  final bool now;
  const _LectureTile(this.l, {this.now = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 52,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.time, style: T.h3.copyWith(fontSize: 14)),
              Text(l.end, style: T.small),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: now ? C.navySoft : Colors.white,
              borderRadius: BorderRadius.circular(S.r),
              border: Border.all(
                color: now ? C.navy : C.line,
                width: now ? 1.4 : 1.2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.subject,
                        style: T.h3.copyWith(
                          color: l.done ? C.muted : C.ink,
                          decoration: l.done
                              ? TextDecoration.lineThrough
                              : null,
                        ),
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
                          Text(l.room, style: T.small),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.person_outline_rounded,
                            size: 14,
                            color: C.muted,
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              l.teacher,
                              overflow: TextOverflow.ellipsis,
                              style: T.small,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (now)
                  const Tag('التالية', color: Colors.white, bg: C.navy)
                else if (l.done)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: C.green,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
