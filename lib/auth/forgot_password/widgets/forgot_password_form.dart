import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/app/view/app_view.dart';
import 'package:instagram_clone/auth/forgot_password/forgot_password.dart';
import 'package:instagram_clone/l10n/l10n.dart';
import 'package:ui/ui.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status.isError) {
          openSnackbar(
            SnackbarMessage.error(
              title: forgotPasswordStatusMessage[state.status]!.title,
              description:
                  forgotPasswordStatusMessage[state.status]?.description,
            ),
            clearIfQueue: true,
          );
        }
        if (state.status.isSuccess) {
          openSnackbar(
            SnackbarMessage.success(
              title: context.l10n.verificationTokenSentText(state.email.value),
            ),
          );
        }
      },
      listenWhen: (previous, current) => previous.status != current.status,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ForgotPasswordEmailField(),
        ],
      ),
    );
  }
}
