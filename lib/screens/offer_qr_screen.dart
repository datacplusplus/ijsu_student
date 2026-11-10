import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../data.dart';
import '../theme.dart';
import '../ui.dart';

/// Discount QR that refreshes every 30 seconds for the shop to scan.
///
/// UI only: [_newCode] makes a random demo string. In production, request a
/// signed one-time token from the server each time the timer resets.
class OfferQrScreen extends StatefulWidget {
  final Offer offer;
  const OfferQrScreen({super.key, required this.offer});
  @override
  State<OfferQrScreen> createState() => _OfferQrScreenState();
}

class _OfferQrScreenState extends State<OfferQrScreen> {
  static const _period = 30;
  late Timer _timer;
  int _left = _period;
  late String _code = _newCode();

  String _newCode() {
    final r = Random();
    final nonce = List.generate(
      12,
      (_) => r.nextInt(16).toRadixString(16),
    ).join();
    return 'IJSU|${student.id}|${widget.offer.shop.hashCode}|$nonce';
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_left <= 1) {
          _left = _period;
          _code = _newCode();
        } else {
          _left--;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.offer;
    final urgent = _left <= 5;
    final accent = urgent ? C.red : C.navy;

    return Scaffold(
      backgroundColor: C.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const PageHeader('رمز الخصم'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: S.page),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  // Shop
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(S.r),
                    ),
                    child: Row(
                      children: [
                        IconBox(o.icon, color: o.color, bg: o.soft, size: 50),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(o.shop, style: T.h3),
                              Text(o.description, style: T.small),
                            ],
                          ),
                        ),
                        Text(
                          '${o.discount}%',
                          style: T.display.copyWith(
                            color: C.navy,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // QR card
                  Container(
                    padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(S.rLg),
                    ),
                    child: Column(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 450),
                          transitionBuilder: (child, a) => FadeTransition(
                            opacity: a,
                            child: ScaleTransition(
                              scale: Tween(begin: .94, end: 1.0).animate(a),
                              child: child,
                            ),
                          ),
                          child: Stack(
                            key: ValueKey(_code),
                            alignment: Alignment.center,
                            children: [
                              QrImageView(
                                data: _code,
                                size: 240,
                                errorCorrectionLevel: QrErrorCorrectLevel.H,
                                eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  color: C.ink,
                                ),
                                dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.circle,
                                  color: C.ink,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Logo(size: 44),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(end: _left / _period),
                            duration: const Duration(milliseconds: 900),
                            builder: (_, v, _) => LinearProgressIndicator(
                              value: v,
                              minHeight: 6,
                              backgroundColor: C.surface,
                              color: accent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            text: 'يتجدد الرمز خلال ',
                            style: T.small.copyWith(color: C.ink2),
                            children: [
                              TextSpan(
                                text: '$_left',
                                style: T.h3.copyWith(color: accent),
                              ),
                              const TextSpan(text: ' ثانية لحمايتك'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        const _Dashed(),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(student.name, style: T.h3),
                                  Text(
                                    '${student.branch} • ${ltr(student.id)}',
                                    style: T.small,
                                  ),
                                ],
                              ),
                            ),
                            Tag(
                              '${o.usesLeft} من ${o.usesTotal} متبقية',
                              color: C.green,
                              bg: C.greenSoft,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'اعرض الرمز للبائع ليمسحه قبل الدفع • صالح حتى ${o.validUntil}',
                    textAlign: TextAlign.center,
                    style: T.small,
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

class _Dashed extends StatelessWidget {
  const _Dashed();
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, c) {
      final n = (c.maxWidth / 9).floor();
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          n,
          (_) => Container(width: 5, height: 1.4, color: C.line),
        ),
      );
    },
  );
}
