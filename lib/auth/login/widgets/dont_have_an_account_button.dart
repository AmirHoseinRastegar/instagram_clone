import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/auth/auth.dart';
import 'package:instagram_clone/l10n/l10n.dart';
import 'package:ui/ui.dart';


/// {@template sign_up_account_button}
/// Sign up widget that contains sign up button.
/// {@endtemplate}
class SignUpNewAccountButton extends StatelessWidget {
  const SignUpNewAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return Tappable.faded(
      onTap: () => cubit.toggleAuthScreen(showLogin: false),
      child: Text.rich(
        overflow: TextOverflow.visible,
        style: context.bodyMedium,
        TextSpan(
          children: [
            TextSpan(text: '${context.l10n.noAccountText} '),
            TextSpan(
              text: '${context.l10n.signUpText}.',
              style: context.bodyMedium?.copyWith(color: AppColors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
