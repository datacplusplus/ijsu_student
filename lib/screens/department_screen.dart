import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';
import 'assistant_screen.dart';

class DepartmentScreen extends StatefulWidget {
  final College college;
  final Department dept;
  const DepartmentScreen({
    super.key,
    required this.college,
    required this.dept,
  });
  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  int _tab = 0;

  static const _tabs = ['نبذة', 'المواد', 'الكادر'];

  List<(String, String)> get _content => switch (_tab) {
    0 => [
      ('رؤية القسم', 'إعداد قادة إداريين قادرين على المنافسة محلياً ودولياً.'),
      ('فرص العمل', 'إدارة المؤسسات، الموارد البشرية، ريادة الأعمال.'),
      ('شروط القبول', 'خريجو الإعدادية بفرعيها، وفق المعدل المعلن سنوياً.'),
    ],
    1 => [
      ('المرحلة الأولى', 'مبادئ الإدارة • الاقتصاد • الرياضيات • الحاسوب'),
      ('المرحلة الثانية', 'السلوك التنظيمي • المحاسبة • الإحصاء'),
      ('المرحلة الثالثة', 'إدارة الموارد البشرية • التسويق • الإنتاج'),
      ('المرحلة الرابعة', 'الإدارة الاستراتيجية • بحث التخرج'),
    ],
    _ => [
      ('أ.د. حسن كاظم', 'رئيس القسم • إدارة استراتيجية'),
      ('م.د. زينب علي', 'تدريسية • موارد بشرية'),
      ('م.م. علي جاسم', 'تدريسي • تسويق'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final d = widget.dept;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 250 + top,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(widget.college.image, fit: BoxFit.cover),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0x330B1220), Color(0xE00B1220)],
                            ),
                          ),
                        ),
                        Positioned(
                          top: top + 8,
                          right: S.page,
                          child: const BackBtn(bg: Colors.white),
                        ),
                        Positioned(
                          bottom: 44,
                          right: S.page,
                          left: S.page,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.college.name,
                                style: T.small.copyWith(
                                  color: C.gold,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                d.name,
                                style: T.display.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SheetLip(),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(S.page, 0, S.page, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 2.1,
                          children: const [
                            Stat(
                              'المراحل',
                              '4 سنوات',
                              color: C.navy,
                              bg: C.navySoft,
                            ),
                            Stat(
                              'نوع الدراسة',
                              'صباحي • مسائي',
                              color: C.navy,
                              bg: C.greenSoft,
                            ),
                            Stat(
                              'نظام الدراسة',
                              'بولونيا',
                              color: C.purple,
                              bg: C.purpleSoft,
                            ),
                            Stat(
                              'معدل القبول',
                              '72%',
                              color: C.amber,
                              bg: C.amberSoft,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Segmented tabs
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: C.surface,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: List.generate(_tabs.length, (i) {
                              final sel = i == _tab;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _tab = i),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: sel
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: sel
                                          ? const [
                                              BoxShadow(
                                                color: Color(0x0F000000),
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Text(
                                      _tabs[i],
                                      textAlign: TextAlign.center,
                                      style: T.h3.copyWith(
                                        fontSize: 13.5,
                                        color: sel ? C.ink : C.muted,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 16),
                        for (final (t, s) in _content) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(S.r),
                              border: Border.all(color: C.line, width: 1.2),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: C.gold,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(t, style: T.h3),
                                      Text(s, style: T.small),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom actions
          Container(
            padding: EdgeInsets.fromLTRB(
              S.page,
              12,
              S.page,
              12 + MediaQuery.paddingOf(context).bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: C.line)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('قدّم على القسم'),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Material(
                    color: C.purpleSoft,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => go(context, const AssistantScreen()),
                      child: const Icon(Icons.auto_awesome, color: C.purple),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
