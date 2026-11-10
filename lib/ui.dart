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
    Icons.arrow_forward_rounded,
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
