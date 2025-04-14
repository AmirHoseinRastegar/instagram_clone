import 'package:flutter/widgets.dart';
import 'package:ui/ui.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton(
      {this.label,
      this.child,
      this.textStyle,
      this.padding,
      this.fadeStrength = FadeStrength.sm,
      this.color,
      this.onTap,
      super.key});
  final String? label;
  final Widget? child;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final FadeStrength fadeStrength;
  final Color? color;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ??
        context.customReversedAdaptiveColor(
          light: AppColors.brightGrey,
          dark: AppColors.emphasizeDarkGrey,
        );
    final effectiveTextStyle = textStyle ?? context.labelLarge;
    final effectivePadding = padding ??
        const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );

    return DefaultTextStyle(
      style: effectiveTextStyle!,
      child: Tappable.faded(
        borderRadius: BorderRadius.circular(6),
        backgroundColor: effectiveColor,
        onTap: onTap,
        fadeStrength: fadeStrength,
        child: Padding(
          padding: effectivePadding,
          child: Align(
            child: child ??
                Text(
                  label!,
                  style: effectiveTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        ),
      ),
    );
  }
}
