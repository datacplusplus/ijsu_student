import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            PageHeader(
              'الإشعارات',
              action: RoundButton(Icons.done_all_rounded),
            ),
            const SizedBox(height: 8),
            _Group('اليوم', noticesToday),
            _Group('سابقاً', noticesEarlier),
          ],
        ),
      ),
    );
  }
}

class _Group extends StatelessWidget {
  final String title;
  final List<Notice> items;
  const _Group(this.title, this.items);
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(S.page, 12, S.page, 4),
        child: Text(title, style: T.h3.copyWith(color: C.muted)),
      ),
      for (final n in items)
        Container(
          color: n.unread ? const Color(0xFFF8FAFF) : null,
          padding: const EdgeInsets.symmetric(horizontal: S.page, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBox(n.icon, color: n.color, bg: n.soft, size: 46),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(n.title, style: T.h3)),
                        Text(n.time, style: T.small),
                      ],
                    ),
                    Text(n.body, style: T.small.copyWith(color: C.ink2)),
                  ],
                ),
              ),
              if (n.unread)
                Container(
                  margin: const EdgeInsetsDirectional.only(start: 8, top: 6),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: C.navy,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
    ],
  );
}
