// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class AppLogo extends StatelessWidget {
  const AppLogo(
      {required this.fit, this.height, this.width, this.color, super.key});
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Assets.images.instagramTextLogo.svg(
      fit: fit,
      height: height ?? 50,
      width: width ?? 50,
      colorFilter: ColorFilter.mode(
        color ?? context.adaptiveColor,
        BlendMode.srcIn,
      ),
    );
  }
}
