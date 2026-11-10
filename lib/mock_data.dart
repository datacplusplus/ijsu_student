import 'package:flutter/material.dart';
import 'theme.dart';

/// Sample data used by the screens. Replace with real API data later.

class Student {
  final String name, id, college, department, stage, studyType, system, branch;
  final String phone, email, admissionYear, status;
  final double gpa;
  final int attendance;
  const Student({
    required this.name,
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

const demoStudent = Student(
  name: 'أحمد علي حسين الموسوي',
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
  final int totalFees, paid;
  final String nextDueDate;
  final int nextDueAmount;
  const Balance(this.totalFees, this.paid, this.nextDueDate, this.nextDueAmount);
  int get remaining => totalFees - paid;
  double get progress => paid / totalFees;
}

const demoBalance = Balance(2500000, 1500000, '15 كانون الأول 2026', 500000);

class Payment {
  final String title, date;
  final int amount;
  final bool isPaid;
  const Payment(this.title, this.date, this.amount, this.isPaid);
}

const demoPayments = [
  Payment('القسط الثاني', '15 كانون الأول 2026', 500000, false),
  Payment('القسط الأول', '01 تشرين الأول 2026', 1000000, true),
  Payment('رسوم التسجيل', '10 أيلول 2026', 500000, true),
];

class Offer {
  final String shop, category, description, validUntil, initial;
  final int discount, usesLeft, usesTotal;
  final Color color, soft;
  final IconData icon;
  final bool featured;
  const Offer({
    required this.shop,
    required this.category,
    required this.description,
    required this.validUntil,
    required this.initial,
    required this.discount,
    required this.usesLeft,
    required this.usesTotal,
    required this.color,
    required this.soft,
    required this.icon,
    this.featured = false,
  });
}

const offerCategories = ['الكل', 'مطاعم', 'مكتبات', 'مقاهي', 'إلكترونيات', 'ملابس'];

const demoOffers = [
  Offer(
    shop: 'مكتبة دار المعرفة',
    category: 'مكتبات',
    description: 'خصم على جميع الكتب والقرطاسية',
    validUntil: '30 تشرين الثاني 2026',
    initial: 'م',
    discount: 20,
    usesLeft: 2,
    usesTotal: 3,
    color: Color(0xFFD9822B),
    soft: Color(0xFFFCEEDD),
    icon: Icons.menu_book_rounded,
    featured: true,
  ),
  Offer(
    shop: 'مطعم البيت البغدادي',
    category: 'مطاعم',
    description: 'خصم على الوجبات للطلبة يومياً',
    validUntil: '31 كانون الأول 2026',
    initial: 'ب',
    discount: 15,
    usesLeft: 5,
    usesTotal: 5,
    color: AppColors.red,
    soft: AppColors.redSoft,
    icon: Icons.restaurant_rounded,
  ),
  Offer(
    shop: 'كافيه ركن القهوة',
    category: 'مقاهي',
    description: 'مشروب مجاني مع كل مشروبين',
    validUntil: '20 كانون الأول 2026',
    initial: 'ق',
    discount: 30,
    usesLeft: 1,
    usesTotal: 4,
    color: Color(0xFF8B5E3C),
    soft: Color(0xFFF3E9E1),
    icon: Icons.local_cafe_rounded,
  ),
  Offer(
    shop: 'تك ستور',
    category: 'إلكترونيات',
    description: 'خصم على اللابتوبات والإكسسوارات',
    validUntil: '15 كانون الثاني 2027',
    initial: 'ت',
    discount: 10,
    usesLeft: 1,
    usesTotal: 1,
    color: AppColors.navyLight,
    soft: AppColors.iconTile,
    icon: Icons.laptop_mac_rounded,
  ),
  Offer(
    shop: 'أزياء الأناقة',
    category: 'ملابس',
    description: 'خصم على التشكيلة الجديدة',
    validUntil: '10 كانون الأول 2026',
    initial: 'أ',
    discount: 25,
    usesLeft: 3,
    usesTotal: 3,
    color: AppColors.purple,
    soft: AppColors.purpleSoft,
    icon: Icons.checkroom_rounded,
  ),
];

String formatIqd(int v) {
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
