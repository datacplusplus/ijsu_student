import 'package:flutter/material.dart';
import 'theme.dart';

/// Sample content (taken from the current app where possible).
/// Replace with real API data later.

const img = 'assets/images';

// ───────────────────────── Branches ─────────────────────────
const branches = [
  ('بغداد', 'المقر الرئيسي • 6 كليات'),
  ('النجف', '4 كليات'),
  ('ميسان', '3 كليات'),
  ('المثنى', '3 كليات'),
  ('ديالى', '3 كليات'),
  ('صلاح الدين', '2 كليتان'),
  ('ذي قار', '3 كليات'),
  ('كركوك', '3 كليات'),
];

// ───────────────────────── News ─────────────────────────
class News {
  final String title, category, date, image, body;
  const News(this.title, this.category, this.date, this.image, this.body);
}

const _lorem =
    'حققت جامعة الإمام جعفر الصادق (ع) المركز السادس على مستوى الجامعات المشاركة، '
    'والمركز الثاني بين الجامعات الأهلية في مسابقة «بنك المعلومات» التي نظمتها وزارة '
    'التعليم العالي والبحث العلمي، بمشاركة واسعة من الجامعات الحكومية والأهلية.\n\n'
    'وأكد رئيس الجامعة أن هذا الإنجاز يعكس مستوى طلبتنا العلمي وروح المنافسة لديهم، '
    'مشيداً بجهود الأساتذة والكوادر التي أسهمت في التحضير للمسابقة.';

const news = [
  News(
    'جامعة الإمام جعفر الصادق (ع) ثانيةً بين الجامعات الأهلية في مسابقة «بنك المعلومات»',
    'الجامعة',
    'الأحد 1 نوفمبر',
    '$img/news_infobank.jpg',
    _lorem,
  ),
  News(
    'أساتذة وطلبة كلية التقنيات الصحية يزورون معرض ومؤتمر الصحة الدولي',
    'التقنيات الصحية',
    'الأحد 1 نوفمبر',
    '$img/news_health.jpg',
    _lorem,
  ),
  News(
    'التقنية الهندسية تنظم ندوة توعوية عن دور وسائل التواصل الاجتماعي',
    'التقنية الهندسية',
    'الأحد 1 نوفمبر',
    '$img/news_seminar.jpg',
    _lorem,
  ),
  News(
    'جامعتنا تشارك بأعمال النسخة الثالثة لمؤتمر التعليم العالي في العراق',
    'الجامعة',
    'السبت 31 أكتوبر',
    '$img/news_conference.jpg',
    _lorem,
  ),
  News(
    'جامعتنا تحتفي بطلبتها الأوائل وتكرّم تفوقهم العلمي',
    'الجامعة',
    'الأربعاء 28 أكتوبر',
    '$img/news_honor.jpg',
    _lorem,
  ),
];

const newsCategories = [
  'الكل',
  'الجامعة',
  'التقنيات الصحية',
  'التقنية الهندسية',
  'فعاليات',
];

// ───────────────────────── Events ─────────────────────────
class Event {
  final String title, place, day, month, image;
  const Event(this.title, this.place, this.day, this.month, this.image);
}

const events = [
  Event(
    'حفل تكريم الطلبة الأوائل',
    'القاعة الكبرى',
    '18',
    'نوفمبر',
    '$img/news_honor.jpg',
  ),
  Event(
    'معرض الصحة الدولي',
    'كلية التقنيات الصحية',
    '24',
    'نوفمبر',
    '$img/news_health.jpg',
  ),
  Event(
    'ندوة الإعلام الرقمي',
    'التقنية الهندسية',
    '02',
    'ديسمبر',
    '$img/news_seminar.jpg',
  ),
];

// ───────────────────────── Colleges ─────────────────────────
class Department {
  final String name, info;
  final IconData icon;
  final Color color, soft;
  const Department(this.name, this.info, this.icon, this.color, this.soft);
}

class College {
  final String name, short, about, image;
  final List<Department> departments;
  const College(
    this.name,
    this.short,
    this.about,
    this.image,
    this.departments,
  );
}

const colleges = [
  College(
    'كلية العلوم الإدارية',
    'العلوم الإدارية',
    'تقديم برامج تعليمية متطورة ومتجددة في مجالات العلوم الإدارية والمالية، '
        'تدعم المجتمع العراقي بالكفاءات العلمية والعملية المؤهلة للمنافسة في سوق العمل.',
    '$img/college_admin.jpg',
    [
      Department(
        'قسم إدارة الأعمال',
        '4 مراحل • صباحي ومسائي',
        Icons.business_center_outlined,
        C.navy,
        C.navySoft,
      ),
      Department(
        'قسم المحاسبة',
        '4 مراحل • صباحي ومسائي',
        Icons.calculate_outlined,
        C.purple,
        C.purpleSoft,
      ),
      Department(
        'قسم العلوم المالية والمصرفية',
        '4 مراحل • صباحي',
        Icons.account_balance_outlined,
        C.green,
        C.greenSoft,
      ),
    ],
  ),
  College(
    'كلية الصيدلة',
    'الصيدلة',
    'الريادة والتميز في مجالات التعليم الصيدلاني والبحث العلمي وخدمة المجتمع '
        'بما يتلاءم مع متطلبات سوق العمل المحلية والعالمية.',
    '$img/college_pharmacy.jpg',
    [
      Department(
        'قسم الصيدلة',
        '5 مراحل • صباحي',
        Icons.medication_outlined,
        C.teal,
        C.tealSoft,
      ),
    ],
  ),
  College(
    'كلية التربية',
    'التربية',
    'إعداد مدرسين أكفاء في مجالات اللغات والعلوم الإنسانية وعلوم القرآن، '
        'وفق معايير الجودة والاعتماد الأكاديمي.',
    '$img/library.jpg',
    [
      Department(
        'قسم اللغة العربية',
        '4 مراحل • صباحي',
        Icons.menu_book_outlined,
        C.amber,
        C.amberSoft,
      ),
      Department(
        'قسم اللغة الإنكليزية',
        '4 مراحل • صباحي ومسائي',
        Icons.translate_outlined,
        C.navy,
        C.navySoft,
      ),
      Department(
        'قسم علوم القرآن',
        '4 مراحل • صباحي',
        Icons.auto_stories_outlined,
        C.green,
        C.greenSoft,
      ),
    ],
  ),
  College(
    'كلية القانون والسياسة',
    'القانون',
    'تأهيل كوادر قانونية وسياسية تمتلك المعرفة والمهارة لخدمة مؤسسات الدولة والمجتمع.',
    '$img/news_conference.jpg',
    [
      Department(
        'قسم القانون',
        '4 مراحل • صباحي ومسائي',
        Icons.gavel_outlined,
        C.purple,
        C.purpleSoft,
      ),
    ],
  ),
];

// ───────────────────────── Student ─────────────────────────
class Student {
  final String name,
      first,
      id,
      college,
      department,
      stage,
      studyType,
      system,
      branch,
      phone,
      email,
      admissionYear,
      status;
  final double gpa;
  final int attendance;
  const Student({
    required this.name,
    required this.first,
    required this.id,
    required this.college,
    required this.department,
    required this.stage,
    required this.studyType,
    required this.system,
    required this.branch,
    required this.phone,
    required this.email,
    required this.admissionYear,
    required this.status,
    required this.gpa,
    required this.attendance,
  });
}

const student = Student(
  name: 'أحمد علي حسين الموسوي',
  first: 'أحمد',
  id: '2026-0148',
  college: 'كلية العلوم الإدارية',
  department: 'إدارة الأعمال',
  stage: 'الأولى',
  studyType: 'صباحي',
  system: 'بولونيا',
  branch: 'IJSU بغداد',
  phone: '+964 770 123 4567',
  email: 'ahmed.ali@ijsu.edu.iq',
  admissionYear: '2026 – 2027',
  status: 'مستمر',
  gpa: 87.4,
  attendance: 94,
);

class Balance {
  final int total, paid, nextAmount;
  final String nextDate;
  const Balance(this.total, this.paid, this.nextAmount, this.nextDate);
  int get remaining => total - paid;
  double get progress => paid / total;
}

const balance = Balance(2500000, 1500000, 500000, '15 كانون الأول 2026');

class Payment {
  final String title, date;
  final int amount;
  final bool paid;
  const Payment(this.title, this.date, this.amount, this.paid);
}

const payments = [
  Payment('القسط الثاني', '15 كانون الأول 2026', 500000, false),
  Payment('القسط الأول', '01 تشرين الأول 2026', 1000000, true),
  Payment('رسوم التسجيل', '10 أيلول 2026', 500000, true),
];

// ───────────────────────── Joy offers ─────────────────────────
class Offer {
  final String shop, category, description, validUntil;
  final int discount, usesLeft, usesTotal;
  final IconData icon;
  final Color color, soft;
  const Offer(
    this.shop,
    this.category,
    this.description,
    this.validUntil,
    this.discount,
    this.usesLeft,
    this.usesTotal,
    this.icon,
    this.color,
    this.soft,
  );
}

const offerCategories = [
  'الكل',
  'مطاعم',
  'مكتبات',
  'مقاهي',
  'إلكترونيات',
  'ملابس',
];

const offers = [
  Offer(
    'مكتبة دار المعرفة',
    'مكتبات',
    'خصم على جميع الكتب والقرطاسية',
    '30 تشرين الثاني',
    20,
    2,
    3,
    Icons.menu_book_outlined,
    C.amber,
    C.amberSoft,
  ),
  Offer(
    'مطعم البيت البغدادي',
    'مطاعم',
    'خصم على الوجبات للطلبة يومياً',
    '31 كانون الأول',
    15,
    5,
    5,
    Icons.restaurant_outlined,
    C.red,
    C.redSoft,
  ),
  Offer(
    'كافيه ركن القهوة',
    'مقاهي',
    'مشروب مجاني مع كل مشروبين',
    '20 كانون الأول',
    30,
    1,
    4,
    Icons.local_cafe_outlined,
    C.teal,
    C.tealSoft,
  ),
  Offer(
    'تك ستور',
    'إلكترونيات',
    'خصم على اللابتوبات والإكسسوارات',
    '15 كانون الثاني',
    10,
    1,
    1,
    Icons.laptop_mac_outlined,
    C.navy,
    C.navySoft,
  ),
  Offer(
    'أزياء الأناقة',
    'ملابس',
    'خصم على التشكيلة الجديدة',
    '10 كانون الأول',
    25,
    3,
    3,
    Icons.checkroom_outlined,
    C.purple,
    C.purpleSoft,
  ),
];

// ───────────────────────── Contact / FAQ ─────────────────────────
const faqs = [
  (
    'ما هي معدلات القبول لتخصص القانون في فرع بغداد؟',
    'تختلف معدلات القبول حسب قناة القبول ونوع الدراسة، ويُعلن عنها سنوياً عبر بوابة القبول.',
  ),
  (
    'ما هي قنوات القبول في جامعة الإمام جعفر الصادق؟',
    'القبول العام، الوقف الشيعي، وخريجي الفرع المهني، إضافة إلى قنوات أخرى تُحدَّد سنوياً.',
  ),
  (
    'هل تتوفر دراسة مسائية؟',
    'نعم، تتوفر الدراسة المسائية في أغلب الأقسام. راجع صفحة القسم لمعرفة التفاصيل.',
  ),
  (
    'كيف أدفع الأقساط الدراسية؟',
    'يمكن الدفع في الحسابات داخل الجامعة أو إلكترونياً عبر التطبيق من قسم الرصيد.',
  ),
];

const assistantSuggestions = [
  'ما هي معدلات القبول لتخصص القانون في فرع بغداد؟',
  'ما هي قنوات القبول في الجامعة؟',
  'ما هو قبول خريجي الفرع المهني (إدارة)؟',
  'كم الأقساط الدراسية لقسم المحاسبة؟',
];

// ───────────────────────── Notifications ─────────────────────────
class Notice {
  final String title, body, time;
  final IconData icon;
  final Color color, soft;
  final bool unread;
  const Notice(
    this.title,
    this.body,
    this.time,
    this.icon,
    this.color,
    this.soft, {
    this.unread = false,
  });
}

const noticesToday = [
  Notice(
    'عرض جديد في Joy',
    'خصم 30% في كافيه ركن القهوة لطلبة الجامعة',
    'منذ 10 د',
    Icons.local_offer_outlined,
    C.amber,
    C.amberSoft,
    unread: true,
  ),
  Notice(
    'تذكير بالقسط',
    'القسط الثاني يستحق في 15 كانون الأول',
    'منذ ساعة',
    Icons.account_balance_wallet_outlined,
    C.red,
    C.redSoft,
    unread: true,
  ),
];

const noticesEarlier = [
  Notice(
    'نتائج الامتحان الشهري',
    'تم نشر نتائج مادة مبادئ الإدارة',
    'أمس',
    Icons.grading_outlined,
    C.green,
    C.greenSoft,
  ),
  Notice(
    'خبر جديد',
    'جامعتنا ثانيةً بين الجامعات الأهلية في «بنك المعلومات»',
    'الأحد',
    Icons.newspaper_outlined,
    C.navy,
    C.navySoft,
  ),
  Notice(
    'تحديث الجدول',
    'تغيير موعد محاضرة الإحصاء إلى الساعة 10:00',
    'السبت',
    Icons.calendar_today_outlined,
    C.purple,
    C.purpleSoft,
  ),
];

// ───────────────────────── Helpers ─────────────────────────
String iqd(int v) {
  final s = v.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return '$b د.ع';
}

/// Keeps numbers / emails / IDs left-to-right inside Arabic text.
String ltr(String s) => '\u2066$s\u2069';
