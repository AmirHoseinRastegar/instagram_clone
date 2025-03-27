import 'package:flutter/widgets.dart';
import 'package:instagram_clone/l10n/l10n.dart';
import 'package:shared/shared.dart';
import 'package:ui/ui.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      throttle: true,
      throttleDuration: 650.ms,
      onTap: () {},
      child: Text(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        context.l10n.forgotPasswordText,
        style: context.titleSmall?.copyWith(
          color: AppColors.blue,
        ),
      ),
    );
  }
}
