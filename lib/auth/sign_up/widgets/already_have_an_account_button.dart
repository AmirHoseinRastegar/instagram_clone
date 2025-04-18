import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:instagram_clone/auth/cubit/cubit/auth_cubit.dart';
import 'package:instagram_clone/l10n/l10n.dart';
import 'package:ui/ui.dart';

/// {@template sign_in_into_account_button}
/// Sign up widget that contains sign up button.
/// {@endtemplate}
class SignInIntoAccountButton extends StatelessWidget {
  /// {@macro sign_in_into_account_button}
  const SignInIntoAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return Tappable.faded(
      onTap: () => cubit.toggleAuthScreen(showLogin: true),
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            TextSpan(
              text: '${context.l10n.alreadyHaveAccountText} ',
              style: context.bodyMedium,
            ),
            TextSpan(
              text: '${context.l10n.loginText}.',
              style: context.bodyMedium?.apply(color: AppColors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
