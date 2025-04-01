import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/auth/login/login.dart';
import 'package:ui/ui.dart';

class LoginInputForm extends StatelessWidget {
  const LoginInputForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isError) {
          openSnackbar(SnackbarMessage.error(
            title: loginSubmissionStatusMessage[state.status]!.title
          ));
        }
      },
      listenWhen: (previous, current) => previous.status != current.status,
      child: const Column(
        children: [
          LoginEmailTextField(),
          SizedBox(
            height: AppSpacing.md,
          ),
          LoginPasswordTextField(),
          SizedBox(
            height: AppSpacing.sm,
          ),
        ],
      ),
    );
  }
}
