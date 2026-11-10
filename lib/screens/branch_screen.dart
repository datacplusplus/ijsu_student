import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';
import 'shell.dart';

/// First launch: choose the university branch.
class BranchScreen extends StatefulWidget {
  const BranchScreen({super.key});
  @override
  State<BranchScreen> createState() => _BranchScreenState();
}

class _BranchScreenState extends State<BranchScreen> {
  int? _sel = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(S.page, 28, S.page, 16),
                children: [
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Logo(size: 64),
                  ),
                  const SizedBox(height: 22),
                  Text('أهلاً بك في', style: T.h2.copyWith(color: C.muted)),
                  Text('جامعة الإمام جعفر الصادق', style: T.display),
                  const SizedBox(height: 6),
                  Text(
                    'اختر فرعك الجامعي لنعرض لك الكليات والأخبار الخاصة به.',
                    style: T.body,
                  ),
                  const SizedBox(height: 26),
                  for (var i = 0; i < branches.length; i++) ...[
                    _BranchTile(
                      name: branches[i].$1,
                      info: branches[i].$2,
                      selected: _sel == i,
                      onTap: () => setState(() => _sel = i),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(S.page, 8, S.page, 16),
              child: FilledButton(
                onPressed: _sel == null
                    ? null
                    : () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => Shell()),
                      ),
                child: Text(
                  _sel == null
                      ? 'اختر فرعاً'
                      : 'متابعة إلى فرع ${branches[_sel!].$1}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BranchTile extends StatelessWidget {
  final String name, info;
  final bool selected;
  final VoidCallback onTap;
  const _BranchTile({
    required this.name,
    required this.info,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected ? C.navySoft : Colors.white,
        borderRadius: BorderRadius.circular(S.r),
        border: Border.all(
          color: selected ? C.navy : C.line,
          width: selected ? 1.6 : 1.2,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(S.r),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              IconBox(
                Icons.location_on_outlined,
                color: selected ? Colors.white : C.navy,
                bg: selected ? C.navy : C.navySoft,
                size: 42,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('IJSU $name', style: T.h3),
                    Text(info, style: T.small),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? C.navy : Colors.transparent,
                  border: Border.all(
                    color: selected ? C.navy : C.line,
                    width: 1.8,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
