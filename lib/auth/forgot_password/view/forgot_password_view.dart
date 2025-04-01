import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/auth/auth.dart';
import 'package:instagram_clone/auth/forgot_password/reset_password/cubit/cubit/change_password_cubit.dart';
import 'package:instagram_clone/l10n/l10n.dart';
import 'package:ui/ui.dart';
import 'package:user_repository/user_repository.dart';

class ManageForgotPasswordPage extends StatelessWidget {
  const ManageForgotPasswordPage({super.key});

  static Route<void> route() => PageRouteBuilder(
        pageBuilder: (_, __, ___) => const ManageForgotPasswordPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChangePasswordCubit(
            userRepository: context.read<UserRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => ForgotPasswordtoggleCubit(),
        ),
        BlocProvider(
          create: (context) => ForgotPasswordCubit(
            userRepository: context.read<UserRepository>(),
          ),
        ),
      ],
      child: const ForgotPasswordView(),
    );
  }
}

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final showForgotPassword = context.select(
      (ForgotPasswordtoggleCubit b) => b.state,
    );
    return PageTransitionSwitcher(
      reverse: showForgotPassword,
      transitionBuilder: (
        child,
        animation,
        secondaryAnimation,
      ) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
      child: showForgotPassword
          ? const ForgotPasswordScreen()
          : const ChangePasswordView(),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      releaseFocus: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(context.l10n.recoveryPasswordText),
        centerTitle: false,
      ),
      body: AppConstrainedScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
        child: Column(
          children: [
            const Gap.v(AppSpacing.xxxlg * 3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ForgotPasswordEmailConfirmationLabel(),
                  const ForgotPasswordForm(),
                  const Align(child: ForgotButtonSendEmailButton()),
                ].spacerBetween(height: AppSpacing.md),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordEmailConfirmationLabel extends StatelessWidget {
  const ForgotPasswordEmailConfirmationLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.forgotPasswordEmailConfirmationText,
      style: context.headlineSmall,
    );
  }
}
