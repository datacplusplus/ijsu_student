import 'package:flutter/material.dart';
import 'theme.dart';

/// Shared building blocks for the redesigned app.

void go(BuildContext context, Widget page) =>
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

/// University logo (real logo cropped from the current app).
class Logo extends StatelessWidget {
  final double size;
  const Logo({super.key, this.size = 40});
  @override
  Widget build(BuildContext context) =>
      Image.asset('assets/images/logo.png', width: size, height: size);
}

/// Rounded photo.
class Photo extends StatelessWidget {
  final String src;
  final double? height, width;
  final double radius;
  const Photo(
    this.src, {
    super.key,
    this.height,
    this.width,
    this.radius = S.r,
  });
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.asset(src, height: height, width: width, fit: BoxFit.cover),
  );
}

/// Photo with dark gradient and text on top.
class PhotoCard extends StatelessWidget {
  final String src;
  final double height;
  final Widget child;
  final Widget? badge;
  final VoidCallback? onTap;
  const PhotoCard({
    super.key,
    required this.src,
    required this.child,
    this.height = 200,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(S.rLg),
        child: SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(src, fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xD90B1220)],
                    stops: [0.35, 1],
                  ),
                ),
              ),
              if (badge != null)
                PositionedDirectional(top: 14, start: 14, child: badge!),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Align(alignment: Alignment.bottomRight, child: child),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// White rounded "lip" placed at the bottom of a header photo so the page
/// content looks like a sheet sliding over the image.
class SheetLip extends StatelessWidget {
  const SheetLip({super.key});
  @override
  Widget build(BuildContext context) => const Positioned(
    left: 0,
    right: 0,
    bottom: -1,
    child: SizedBox(
      height: 28,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(S.rLg)),
        ),
      ),
    ),
  );
}

/// Small pill label.
class Tag extends StatelessWidget {
  final String text;
  final Color color, bg;
  final IconData? icon;
  const Tag(
    this.text, {
    super.key,
    this.color = C.ink,
    this.bg = Colors.white,
    this.icon,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
        ],
        Text(
          text,
          style: T.small.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 11.5,
          ),
        ),
      ],
    ),
  );
}

/// Section header: title + optional action.
class Section extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const Section(this.title, {super.key, this.action, this.onAction});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Expanded(child: Text(title, style: T.h2)),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: T.label.copyWith(
                decoration: TextDecoration.underline,
                decorationColor: C.navy,
              ),
            ),
          ),
      ],
    ),
  );
}

/// Horizontal filter chips.
class Chips extends StatelessWidget {
  final List<String> items;
  final int selected;
  final ValueChanged<int> onSelect;
  const Chips({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 42,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: S.page),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (_, i) {
        final sel = i == selected;
        return GestureDetector(
          onTap: () => onSelect(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: sel ? C.navy : C.surface,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              items[i],
              style: T.h3.copyWith(
                fontSize: 13.5,
                color: sel ? Colors.white : C.ink2,
                fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        );
      },
    ),
  );
}

/// Pastel stat block (label small, value big).
class Stat extends StatelessWidget {
  final String label, value;
  final Color color, bg;
  const Stat(
    this.label,
    this.value, {
    super.key,
    required this.color,
    required this.bg,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(S.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: T.small.copyWith(color: color.withValues(alpha: .8)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: T.h2.copyWith(color: color, fontWeight: FontWeight.w800),
        ),
      ],
    ),
  );
}

/// Pastel icon square.
class IconBox extends StatelessWidget {
  final IconData icon;
  final Color color, bg;
  final double size;
  const IconBox(
    this.icon, {
    super.key,
    this.color = C.navy,
    this.bg = C.navySoft,
    this.size = 46,
  });
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(size * .32),
    ),
    child: Icon(icon, color: color, size: size * .5),
  );
}

/// Outlined list row card with chevron.
class RowCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  const RowCard({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(S.r),
      side: const BorderSide(color: C.line, width: 1.2),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(S.r),
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: T.h3),
                  if (subtitle != null) Text(subtitle!, style: T.small),
                ],
              ),
            ),
            trailing ?? const Icon(Icons.chevron_left_rounded, color: C.muted),
          ],
        ),
      ),
    ),
  );
}

/// Round icon button (back, bell, search…).
class RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool dot;
  final Color bg;
  const RoundButton(
    this.icon, {
    super.key,
    this.onTap,
    this.dot = false,
    this.bg = C.surface,
  });
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Material(
        color: bg,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap ?? () {},
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, size: 21, color: C.ink),
          ),
        ),
      ),
      if (dot)
        Positioned(
          top: 10,
          right: 11,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: C.red,
              shape: BoxShape.circle,
              border: Border.all(color: bg, width: 1.5),
            ),
          ),
        ),
    ],
  );
}

/// Back button that pops the route.
class BackBtn extends StatelessWidget {
  final Color bg;
  const BackBtn({super.key, this.bg = C.surface});
  @override
  Widget build(BuildContext context) => RoundButton(
    Icons.arrow_back_rounded,
    bg: bg,
    onTap: () => Navigator.maybePop(context),
  );
}

/// Simple page header: back · title · optional action.
class PageHeader extends StatelessWidget {
  final String title;
  final Widget? action;
  final bool back;
  const PageHeader(this.title, {super.key, this.action, this.back = true});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(S.page, 8, S.page, 8),
    child: Row(
      children: [
        if (back) const BackBtn() else const SizedBox(width: 44),
        Expanded(
          child: Text(title, style: T.h2, textAlign: TextAlign.center),
        ),
        action ?? const SizedBox(width: 44),
      ],
    ),
  );
}

/// Large left-aligned page title (like iOS large titles).
class BigTitle extends StatelessWidget {
  final String title;
  final String? overline;
  final Widget? trailing;
  const BigTitle(this.title, {super.key, this.overline, this.trailing});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(S.page, 12, S.page, 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (overline != null) Text(overline!, style: T.small),
              Text(title, style: T.display),
            ],
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

/// Search field.
class SearchField extends StatelessWidget {
  final String hint;
  const SearchField(this.hint, {super.key});
  @override
  Widget build(BuildContext context) => TextField(
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.search_rounded),
    ),
  );
}

/// Thin divider with page padding.
class Hairline extends StatelessWidget {
  const Hairline({super.key});
  @override
  Widget build(BuildContext context) => const Divider(height: 1);
}

/// Four-colour Google "G" mark.
class GoogleLogo extends StatelessWidget {
  final double size;
  const GoogleLogo({super.key, this.size = 22});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _GPainter());
}

class _GPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width * .2;
    final r = Rect.fromLTWH(w / 2, w / 2, s.width - w, s.height - w);
    Paint p(Color c) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = w;
    const deg = 3.14159265 / 180;
    canvas.drawArc(r, -40 * deg, -100 * deg, false, p(const Color(0xFFEA4335)));
    canvas.drawArc(r, -140 * deg, -90 * deg, false, p(const Color(0xFFFBBC05)));
    canvas.drawArc(r, 130 * deg, -90 * deg, false, p(const Color(0xFF34A853)));
    canvas.drawArc(r, 40 * deg, -40 * deg, false, p(const Color(0xFF4285F4)));
    canvas.drawRect(
      Rect.fromLTWH(s.width / 2, s.height / 2 - w / 2, s.width / 2 - w / 4, w),
      Paint()..color = const Color(0xFF4285F4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Field label above an input.
class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 16),
    child: Text(text, style: T.h3.copyWith(fontSize: 13.5)),
  );
}

/// Row of equal-width selectable boxes (gender, study type…).
/// An option is (label, icon?, enabled?, note?).
class Choice extends StatelessWidget {
  final List<(String, IconData?, bool, String?)> options;
  final int selected;
  final ValueChanged<int> onSelect;
  const Choice({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var i = 0; i < options.length; i++) ...[
        if (i > 0) const SizedBox(width: 8),
        Expanded(child: _box(i)),
      ],
    ],
  );

  Widget _box(int i) {
    final (label, icon, enabled, note) = options[i];
    final sel = i == selected;
    return GestureDetector(
      onTap: enabled ? () => onSelect(i) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: icon != null ? 76 : 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: !enabled
              ? Colors.white
              : sel
              ? C.navySoft
              : C.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: sel ? C.navy : (enabled ? Colors.transparent : C.line),
            width: sel ? 1.4 : 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: sel ? C.navy : C.ink2),
              const SizedBox(height: 4),
            ],
            Text(
              label,
              style: T.h3.copyWith(
                fontSize: 14,
                color: !enabled ? C.muted : (sel ? C.navy : C.ink2),
                fontWeight: sel ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            if (note != null) Text(note, style: T.small.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

/// Wrap of pill options (admission channel…).
class PillChoice extends StatelessWidget {
  final List<String> options;
  final int selected;
  final ValueChanged<int> onSelect;
  const PillChoice({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelect,
  });
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (var i = 0; i < options.length; i++)
        GestureDetector(
          onTap: () => onSelect(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            decoration: BoxDecoration(
              color: i == selected ? C.navy : C.surface,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              options[i],
              style: T.h3.copyWith(
                fontSize: 13.5,
                color: i == selected ? Colors.white : C.ink2,
              ),
            ),
          ),
        ),
    ],
  );
}

/// Read-only dropdown-looking field (demo: opens a simple bottom sheet).
class SelectField extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final IconData? icon;
  const SelectField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: C.surface,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final v = await showModalBottomSheet<String>(
          context: context,
          backgroundColor: Colors.white,
          showDragHandle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(S.rLg)),
          ),
          builder: (c) => SafeArea(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(S.page, 0, S.page, 16),
              children: [
                for (final it in items)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(it, style: T.h3),
                    trailing: it == value
                        ? const Icon(Icons.check_rounded, color: C.navy)
                        : null,
                    onTap: () => Navigator.pop(c, it),
                  ),
              ],
            ),
          ),
        );
        if (v != null) onChanged(v);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: C.muted),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: T.h3.copyWith(fontSize: 14),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: C.muted),
          ],
        ),
      ),
    ),
  );
}
