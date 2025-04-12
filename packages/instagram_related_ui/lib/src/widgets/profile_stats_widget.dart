import 'package:flutter/widgets.dart';
import 'package:shared/shared.dart';
import 'package:ui/ui.dart';

class ProfileStatsWidget extends StatelessWidget {
  const ProfileStatsWidget(
    {
    required this.name,
    required this.value,
     this.onTap,
    super.key,
  });
  final String name;
  final int value;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            name.toLowerCase(),
            maxLines: 1,
            style: context.bodyLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class StatsValue extends StatelessWidget {
  const StatsValue({required this.value, super.key});
  final int value;
  @override
  Widget build(BuildContext context) {
    final applyLargFont = value <= 9999;
    final dynamicTexStyle = applyLargFont
        ? context.titleLarge?.copyWith(fontSize: 20)
        : context.bodyLarge;
    return Text(
      value.compactShort(context),
      style: dynamicTexStyle?.copyWith(fontWeight: AppFontWeight.bold),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}
