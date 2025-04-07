import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/auth/cubit/cubit/forgot_password_toggle_cubit.dart';
import 'package:instagram_clone/auth/forgot_password/forgot_password.dart';
import 'package:instagram_clone/l10n/l10n.dart';
import 'package:shared/shared.dart';
import 'package:ui/ui.dart';

class ForgotPasswordManager extends StatelessWidget {
  const ForgotPasswordManager({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordtoggleCubit(),
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      throttle: true,
      throttleDuration: 650.ms,
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          ForgotPasswordPage.route(),
          (_) => true,
        );
      },
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
