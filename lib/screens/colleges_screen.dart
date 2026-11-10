import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';
import 'department_screen.dart';

class CollegesScreen extends StatefulWidget {
  const CollegesScreen({super.key});
  @override
  State<CollegesScreen> createState() => _CollegesScreenState();
}

class _CollegesScreenState extends State<CollegesScreen> {
  int _sel = 0;

  @override
  Widget build(BuildContext context) {
    final c = colleges[_sel];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const BigTitle('الكليات والأقسام', overline: 'فرع بغداد'),
          Chips(
            items: [for (final c in colleges) c.short],
            selected: _sel,
            onSelect: (i) => setState(() => _sel = i),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: S.page),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Column(
                key: ValueKey(_sel),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PhotoCard(
                    src: c.image,
                    height: 210,
                    badge: Tag(
                      deptCount(c.departments.length),
                      icon: Icons.school_outlined,
                    ),
                    child: Text(
                      c.name,
                      style: T.h1.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(c.about, style: T.body),
                  const SizedBox(height: 22),
                  Section('الأقسام', action: 'اسأل عن معدلات القبول'),
                  for (final d in c.departments) ...[
                    RowCard(
                      leading: IconBox(d.icon, color: d.color, bg: d.soft),
                      title: d.name,
                      subtitle: d.info,
                      onTap: () =>
                          go(context, DepartmentScreen(college: c, dept: d)),
                    ),
                    const SizedBox(height: 10),
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
