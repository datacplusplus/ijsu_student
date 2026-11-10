import 'package:flutter/material.dart';
import '../theme.dart';
import 'dashboard_screen.dart';
import 'balance_screen.dart';
import 'joy_screen.dart';
import 'profile_screen.dart';

/// Bottom navigation for the student area — same pill style as the main app.
class StudentShell extends StatefulWidget {
  final int initialIndex;
  const StudentShell({super.key, this.initialIndex = 0});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  late int _index = widget.initialIndex;

  static const _items = [
    (Icons.home_rounded, 'الرئيسية'),
    (Icons.account_balance_wallet_rounded, 'الرصيد'),
    (Icons.local_offer_rounded, 'Joy'),
    (Icons.person_rounded, 'حسابي'),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(onOpenTab: (i) => setState(() => _index = i)),
      const BalanceScreen(),
      const JoyScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                color: Color(0x14000000), blurRadius: 24, offset: Offset(0, -4))
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: List.generate(_items.length, (i) {
                final selected = i == _index;
                final (icon, label) = _items[i];
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _index = i),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                          width: selected ? 72 : 48,
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                selected ? AppColors.navy : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(icon,
                              color: selected
                                  ? AppColors.gold
                                  : AppColors.muted),
                        ),
                        const SizedBox(height: 4),
                        Text(label,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  selected ? FontWeight.w800 : FontWeight.w500,
                              color:
                                  selected ? AppColors.navy : AppColors.muted,
                            )),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
