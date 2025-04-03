import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/app/view/app_view.dart';
import 'package:instagram_clone/auth/sign_up/sign_up.dart';
import 'package:ui/ui.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignupState>(
      listener: (context, state) {
        if (state.submissionStatus.isError) {
          openSnackbar(
            SnackbarMessage.error(
              title:
                  signupSubmissionStatusMessage[state.submissionStatus]!.title,
                
              description: signupSubmissionStatusMessage[state.submissionStatus]
                  ?.description,
            ),
            clearIfQueue: true,
          );
        }
      },
      listenWhen: (previous, current) =>
          current.submissionStatus != previous.submissionStatus,
      child: Column(
        children: [
          const SizedBox(
            height: AppSpacing.md,
          ),
          //email
          const EmailTextField(),

          //fullname
          const FullNameTextField(),

          //usename
          const UsernameTextField(),

          //password
          const PasswordTextField(),
        ].spacerBetween(height: AppSpacing.md),
      ),
    );
  }
}
