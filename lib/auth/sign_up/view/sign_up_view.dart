import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/auth/sign_up/sign_up.dart';
import 'package:instagram_related_ui/instagram_related_ui.dart';
import 'package:ui/ui.dart';
import 'package:user_repository/user_repository.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(
        userRepository: context.read<UserRepository>(),
      ),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      resizeToAvoidBottomInset: true,
      releaseFocus: true,
      body: AppConstrainedScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xlg,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            children: [
              SizedBox(
                height: AppSpacing.xxlg + AppSpacing.xlg,
              ),
              AppLogo(fit: BoxFit.fitHeight),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(child: AvatarImagePicker()),
                    SignUpForm(),
                    Gap.v(AppSpacing.xlg),
                    Align(
                      child: SignUpButton(),
                    ),
                  ],
                ),
              ),
              SignInIntoAccountButton(),
            ],
          ),
        ),
      ),
    );
  }
}
