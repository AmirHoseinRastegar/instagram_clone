import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/auth/login/login.dart';

import 'package:ui/ui.dart';
import 'package:user_repository/user_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginCubit(userRepository: context.read<UserRepository>()),
      child: const LoginView(),
    );
  }
}
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      releaseFocus: true,
      body: AppConstrainedScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xlg,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///space from top
            const SizedBox(
              height: AppSpacing.xxxlg * 2.5,
            ),

            ///logo
            const AppLogo(
              fit: BoxFit.cover,
              width: 65,
              height: 65,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///text fields of login screen
                  const LoginInputForm(),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: ForgotPasswordButton(),
                  ),
                  const Align(
                    child: SignInButton(),
                  ),
                  Row(
                    children: <Widget>[
                      const Expanded(
                        child: AppDivider(
                          endIndent: AppSpacing.sm,
                          indent: AppSpacing.md,
                          color: AppColors.white,
                          height: 36,
                        ),
                      ),
                      Text(
                        'OR',
                        style: context.titleMedium,
                      ),
                      const Expanded(
                        child: AppDivider(
                          color: AppColors.white,
                          indent: AppSpacing.sm,
                          endIndent: AppSpacing.md,
                          height: 36,
                        ),
                      ),
                    ],
                  ),

                  AuthProviderSignInButton(
                    provider: AuthProvider.google,
                    onPressed: () {
                      context.read<LoginCubit>().loginWithGoogle();
                    },
                  ),
                  AuthProviderSignInButton(
                    provider: AuthProvider.github,
                    onPressed: () {
                      context.read<LoginCubit>().loginWithGithub();
                    },
                  ),
                ],
              ),
            ),
            const SignUpNewAccountButton(),
            // ElevatedButton(
            //   onPressed: () => context.read<UserRepository>().logOut(),
            //   child: const Text(
            //     'logOut',
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
