import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';
import 'credentials_screen.dart';

/// Demo Google account returned by the (simulated) Google sign-in.
const googleEmail = 'ahmed.ali@gmail.com';
const googleName = 'Ahmed Ali';

/// Simulated Google account chooser. Returns true if an account was picked.
Future<bool> showGoogleChooser(BuildContext context) async {
  final ok = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.white,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(S.rLg)),
    ),
    builder: (c) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(S.page, 0, S.page, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const GoogleLogo(size: 30),
            const SizedBox(height: 12),
            Text('اختر حساباً', style: T.h2),
            Text(
              'للمتابعة إلى تطبيق جامعة الإمام جعفر الصادق',
              style: T.small,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            RowCard(
              onTap: () => Navigator.pop(c, true),
              leading: const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFF4285F4),
                child: Text(
                  'A',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              title: googleName,
              subtitle: ltr(googleEmail),
            ),
            const SizedBox(height: 10),
            RowCard(
              onTap: () => Navigator.pop(c, true),
              leading: const IconBox(
                Icons.person_add_alt_outlined,
                color: C.ink2,
                bg: C.surface,
                size: 44,
              ),
              title: 'استخدام حساب آخر',
            ),
          ],
        ),
      ),
    ),
  );
  return ok ?? false;
}

/// First-time registration after Google sign-in (3 steps).
class RegisterScreen extends StatefulWidget {
  final int initialStep;
  const RegisterScreen({super.key, this.initialStep = 0});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late int _step = widget.initialStep;

  // Step 1 — personal
  int _gender = 0;
  DateTime? _birth;
  // Step 2 — university
  String _branch = 'IJSU بغداد';
  String _year = '2026 – 2027';
  int _channel = 0;
  int _college = 0;
  String _dept = colleges[0].departments[0].name;
  int _stage = 0;
  int _shift = 0;
  int _system = 1;
  // Step 3 — previous study
  int _schoolType = 0; // 0 إعدادي · 1 مهني · 2 وقف
  int _track = 0; // sub-branch of إعدادي / مهني

  static const _channels = [
    'القبول العام',
    'ذوي الشهداء',
    'السجناء السياسيون',
    'ضحايا الإرهاب',
    'ذوي الاحتياجات الخاصة',
    'أبناء الهيئة التدريسية',
    'أخرى',
  ];

  Future<void> _pickBirth() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(2007, 1, 1),
      firstDate: DateTime(1960),
      lastDate: DateTime(DateTime.now().year - 15, 12, 31),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'اختر تاريخ الميلاد',
      builder: (c, child) => Theme(
        data: Theme.of(c).copyWith(
          colorScheme: Theme.of(c).colorScheme.copyWith(primary: C.navy),
        ),
        child: child!,
      ),
    );
    if (d != null) setState(() => _birth = d);
  }

  String _gradYear = '2026';
  bool _before2003 = false;
  bool _agree = true;

  static const _titles = [
    ('عرّفنا بنفسك', 'البيانات كما في الوثائق الرسمية'),
    ('دراستك في الجامعة', 'تتغيّر الأقسام تلقائياً حسب الكلية'),
    ('الدراسة السابقة', 'خطوة أخيرة قبل تفعيل حسابك'),
  ];

  void _next() {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const CredentialsScreen(afterRegistration: true),
        ),
      );
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (title, sub) = _titles[_step];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header: back · progress · step count
            Padding(
              padding: const EdgeInsets.fromLTRB(S.page, 8, S.page, 4),
              child: Row(
                children: [
                  RoundButton(Icons.arrow_back_rounded, onTap: _back),
                  const SizedBox(width: 14),
                  for (var i = 0; i < 3; i++) ...[
                    if (i > 0) const SizedBox(width: 6),
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 5,
                        decoration: BoxDecoration(
                          color: i <= _step ? C.navy : C.line,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 14),
                  Text(
                    '${_step + 1}/3',
                    style: T.h3.copyWith(color: C.muted, fontSize: 13),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(S.page, 14, S.page, 20),
                children: [
                  Text(title, style: T.display),
                  Text(sub, style: T.small),
                  const SizedBox(height: 6),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: KeyedSubtree(
                      key: ValueKey(_step),
                      child: switch (_step) {
                        0 => _personal(),
                        1 => _university(),
                        _ => _school(),
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(S.page, 8, S.page, 14),
              child: FilledButton.icon(
                onPressed: (_step == 2 && !_agree) ? null : _next,
                icon: Icon(
                  _step == 2
                      ? Icons.check_rounded
                      : Icons.arrow_forward_rounded,
                ),
                label: Text(_step == 2 ? 'إنشاء الحساب' : 'التالي'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────── Step 1: personal ─────────────
  Widget _personal() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: C.navySoft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const GoogleLogo(size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                ltr(googleEmail),
                style: T.h3.copyWith(fontSize: 13.5, color: C.navy),
              ),
            ),
            const Icon(Icons.verified_rounded, color: C.green, size: 20),
          ],
        ),
      ),
      const FieldLabel('الاسم الرباعي'),
      Row(
        children: const [
          Expanded(child: _Input('الاسم', initial: 'أحمد')),
          SizedBox(width: 8),
          Expanded(child: _Input('اسم الأب', initial: 'علي')),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        children: const [
          Expanded(child: _Input('اسم الجد', initial: 'حسين')),
          SizedBox(width: 8),
          Expanded(child: _Input('والد الجد')),
        ],
      ),
      Row(
        children: const [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [FieldLabel('اللقب'), _Input('مثال: الموسوي')],
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [FieldLabel('اسم الأم'), _Input('الاسم الثلاثي')],
            ),
          ),
        ],
      ),
      const FieldLabel('الجنس'),
      Choice(
        options: const [('ذكر', null, true, null), ('أنثى', null, true, null)],
        selected: _gender,
        onSelect: (i) => setState(() => _gender = i),
      ),
      const FieldLabel('تاريخ الميلاد'),
      Material(
        color: C.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _pickBirth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 20,
                  color: C.navy,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _birth == null
                        ? 'اختر التاريخ'
                        : ltr(
                            '${_birth!.day} / ${_birth!.month} / ${_birth!.year}',
                          ),
                    style: _birth == null
                        ? T.body.copyWith(color: C.muted)
                        : T.h3.copyWith(fontSize: 14),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded, color: C.muted),
              ],
            ),
          ),
        ),
      ),
      const FieldLabel('رقم البطاقة الموحدة'),
      const _Input('0000 0000 0000', number: true),
      const FieldLabel('رقم الهاتف'),
      const _Input('7XX XXX XXXX', number: true, prefix: '+964'),
    ],
  );

  // ───────────── Step 2: university ─────────────
  Widget _university() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FieldLabel('الفرع'),
                SelectField(
                  value: _branch,
                  items: [for (final b in branches) 'IJSU ${b.$1}'],
                  onChanged: (v) => setState(() => _branch = v),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FieldLabel('سنة القبول'),
                SelectField(
                  value: _year,
                  items: const ['2026 – 2027', '2025 – 2026', '2024 – 2025'],
                  onChanged: (v) => setState(() => _year = v),
                ),
              ],
            ),
          ),
        ],
      ),
      const FieldLabel('قناة القبول'),
      PillChoice(
        options: _channels,
        selected: _channel,
        onSelect: (i) => setState(() => _channel = i),
      ),
      if (_channel != 0)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              const Icon(Icons.attach_file_rounded, size: 16, color: C.amber),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'سيُطلب منك رفع الوثيقة المؤيدة لهذه القناة لاحقاً.',
                  style: T.small.copyWith(color: C.amber),
                ),
              ),
            ],
          ),
        ),
      const FieldLabel('الكلية'),
      SelectField(
        icon: Icons.account_balance_outlined,
        value: colleges[_college].name,
        items: [for (final c in colleges) c.name],
        onChanged: (v) => setState(() {
          _college = colleges.indexWhere((c) => c.name == v);
          _dept = colleges[_college].departments.first.name;
        }),
      ),
      const FieldLabel('القسم'),
      SelectField(
        icon: Icons.school_outlined,
        value: _dept,
        items: [for (final d in colleges[_college].departments) d.name],
        onChanged: (v) => setState(() => _dept = v),
      ),
      const FieldLabel('المرحلة'),
      Choice(
        options: const [
          ('1', null, true, null),
          ('2', null, true, null),
          ('3', null, true, null),
          ('4', null, true, null),
          ('5', null, false, null),
        ],
        selected: _stage,
        onSelect: (i) => setState(() => _stage = i),
      ),
      const FieldLabel('نوع الدراسة'),
      Choice(
        options: const [
          ('صباحي', null, true, null),
          ('مسائي', null, true, null),
        ],
        selected: _shift,
        onSelect: (i) => setState(() => _shift = i),
      ),
      const FieldLabel('نظام الدراسة'),
      Choice(
        options: const [
          ('سنوي', null, true, null),
          ('بولونيا', null, true, null),
          ('كورسات', null, false, 'غير متاح'),
        ],
        selected: _system,
        onSelect: (i) => setState(() => _system = i),
      ),
    ],
  );

  // ───────────── Step 3: secondary school ─────────────
  Widget _school() {
    const stages = ['الأولى', 'الثانية', 'الثالثة', 'الرابعة'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('نوع الدراسة السابقة'),
        Choice(
          options: const [
            ('إعدادي', Icons.school_outlined, true, null),
            ('مهني', Icons.handyman_outlined, true, null),
            ('وقف', Icons.mosque_outlined, true, null),
          ],
          selected: _schoolType,
          onSelect: (i) => setState(() {
            _schoolType = i;
            _track = 0;
          }),
        ),
        if (_schoolType == 0) ...[
          const FieldLabel('الفرع'),
          PillChoice(
            options: const ['علمي تطبيقي', 'علمي أحيائي', 'أدبي'],
            selected: _track,
            onSelect: (i) => setState(() => _track = i),
          ),
        ] else if (_schoolType == 1) ...[
          const FieldLabel('الاختصاص'),
          PillChoice(
            options: const ['صناعي', 'تجاري', 'زراعي', 'فنون تطبيقية'],
            selected: _track,
            onSelect: (i) => setState(() => _track = i),
          ),
        ],
        const FieldLabel('الرقم الامتحاني'),
        const _Input('مثال: 1234567890', number: true),
        const FieldLabel('سنة التخرج'),
        SelectField(
          value: _gradYear,
          items: [for (var y = 2026; y >= 2015; y--) '$y'],
          onChanged: (v) => setState(() => _gradYear = v),
        ),
        const SizedBox(height: 10),
        Material(
          color: C.surface,
          borderRadius: BorderRadius.circular(16),
          child: CheckboxListTile(
            value: _before2003,
            onChanged: (v) => setState(() => _before2003 = v!),
            title: Text(
              'تخرّجت قبل عام 2003',
              style: T.h3.copyWith(fontSize: 14),
            ),
            activeColor: C.navy,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, right: 4),
          child: Text(
            'سنة التخرج مطلوبة لخريجي 2003 فما بعد، ولا تُطلب لخريجي الوقف.',
            style: T.small.copyWith(fontSize: 11),
          ),
        ),
        const SizedBox(height: 18),

        // Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(S.r),
            border: Border.all(color: C.line, width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('ملخص بياناتك', style: T.h2)),
                  GestureDetector(
                    onTap: () => setState(() => _step = 0),
                    child: Text(
                      'تعديل',
                      style: T.label.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: C.navy,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: C.goldSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Text('أ', style: T.h2.copyWith(color: C.amber)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('أحمد علي حسين', style: T.h3),
                        Text(
                          '${_dept.replaceFirst('قسم ', '')} • المرحلة ${stages[_stage]} • '
                          '${_shift == 0 ? 'صباحي' : 'مسائي'} • '
                          '${_system == 0 ? 'سنوي' : 'بولونيا'}',
                          style: T.small,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () => setState(() => _agree = !_agree),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _agree,
                activeColor: C.navy,
                visualDensity: VisualDensity.compact,
                onChanged: (v) => setState(() => _agree = v!),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'أقرّ بصحة البيانات، وأعلم أن الجامعة ستطابقها مع سجلات القبول.',
                    style: T.body.copyWith(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Filled text input used in the registration form.
class _Input extends StatelessWidget {
  final String hint;
  final String? initial;
  final bool number;
  final String? prefix;
  const _Input(this.hint, {this.initial, this.number = false, this.prefix});

  @override
  Widget build(BuildContext context) => TextFormField(
    initialValue: initial,
    keyboardType: number ? TextInputType.number : TextInputType.text,
    textDirection: number ? TextDirection.ltr : null,
    style: T.h3.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
    decoration: InputDecoration(
      hintText: hint,
      hintTextDirection: number ? TextDirection.ltr : null,
      prefixIcon: prefix != null
          ? Container(
              width: 70,
              alignment: Alignment.center,
              margin: const EdgeInsetsDirectional.only(end: 8),
              decoration: const BoxDecoration(
                border: BorderDirectional(
                  end: BorderSide(color: C.line, width: 1.2),
                ),
              ),
              child: Text(
                prefix!,
                textDirection: TextDirection.ltr,
                style: T.h3.copyWith(color: C.navy, fontSize: 14),
              ),
            )
          : null,
    ),
  );
}
