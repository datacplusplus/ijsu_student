import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../widgets.dart';

/// Discount QR that refreshes every 30 seconds for the shop to scan.
///
/// UI only: [_newCode] makes a random demo string. In the real app, ask
/// your server for a signed one-time token each time the timer resets.
class OfferQrScreen extends StatefulWidget {
  final Offer offer;
  const OfferQrScreen({super.key, required this.offer});

  @override
  State<OfferQrScreen> createState() => _OfferQrScreenState();
}

class _OfferQrScreenState extends State<OfferQrScreen> {
  static const _period = 30;
  late Timer _timer;
  int _secondsLeft = _period;
  late String _code = _newCode();

  String _newCode() {
    final r = Random();
    final nonce = List.generate(12, (_) => r.nextInt(16).toRadixString(16)).join();
    return 'IJSU|${demoStudent.id}|${widget.offer.shop.hashCode}|$nonce';
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_secondsLeft <= 1) {
          _secondsLeft = _period;
          _code = _newCode();
        } else {
          _secondsLeft--;
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
    const s = demoStudent;
    final urgent = _secondsLeft <= 5;

    return Scaffold(
      appBar: AppBar(
        leading: const CircleBackButton(),
        leadingWidth: 64,
        title: const Text('رمز الخصم',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          // ---------- Shop ----------
          SoftCard(
            child: Row(
              children: [
                IconTile(o.icon, color: o.color, background: o.soft, size: 52),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(o.shop,
                          style: const TextStyle(
                              fontSize: 16.5, fontWeight: FontWeight.w800)),
                      Text(o.description,
                          style: const TextStyle(
                              color: AppColors.muted, fontSize: 13)),
                    ],
                  ),
                ),
                Text('${o.discount}%',
                    style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 30,
                        fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ---------- QR ----------
          SoftCard(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 450),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: ScaleTransition(
                          scale: Tween(begin: 0.94, end: 1.0).animate(anim),
                          child: child),
                    ),
                    child: QrImageView(
                      key: ValueKey(_code),
                      data: _code,
                      size: 230,
                      errorCorrectionLevel: QrErrorCorrectLevel.H,
                      eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square, color: AppColors.ink),
                      dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.circle,
                          color: AppColors.ink),
                      embeddedImageStyle:
                          const QrEmbeddedImageStyle(size: Size(46, 46)),
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                // countdown bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(end: _secondsLeft / _period),
                    duration: const Duration(milliseconds: 900),
                    builder: (_, v, _) => LinearProgressIndicator(
                      value: v,
                      minHeight: 7,
                      backgroundColor: AppColors.iconTile,
                      color: urgent ? AppColors.red : AppColors.navy,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.autorenew_rounded,
                        size: 16,
                        color: urgent ? AppColors.red : AppColors.muted),
                    const SizedBox(width: 6),
                    Text.rich(
                      TextSpan(
                        text: 'يتجدد الرمز خلال ',
                        style: const TextStyle(color: AppColors.muted),
                        children: [
                          TextSpan(
                            text: '$_secondsLeft',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color:
                                    urgent ? AppColors.red : AppColors.ink),
                          ),
                          const TextSpan(text: ' ثانية لحمايتك'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const _DashedLine(),
                const SizedBox(height: 16),

                // student
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.name,
                              style: const TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w800)),
                          Text('${s.branch} • ${ltr(s.id)}',
                              style: const TextStyle(
                                  color: AppColors.muted, fontSize: 12.5)),
                        ],
                      ),
                    ),
                    Pill('${o.usesLeft} من ${o.usesTotal} متبقية',
                        color: AppColors.green,
                        background: AppColors.greenSoft),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('اعرض الرمز للبائع ليمسحه قبل الدفع • صالح حتى ${o.validUntil}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.muted, fontSize: 13)),
        ],
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      final n = (c.maxWidth / 9).floor();
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
            n,
            (_) => Container(
                width: 5, height: 1.4, color: const Color(0xFFD9D6CE))),
      );
    });
  }
}
