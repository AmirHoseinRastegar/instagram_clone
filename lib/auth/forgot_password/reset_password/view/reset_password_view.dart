// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/auth/auth.dart';
import 'package:instagram_clone/auth/forgot_password/reset_password/widgets/widgets.dart';
import 'package:instagram_clone/l10n/l10n.dart';
import 'package:ui/ui.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  void _confirmGoBack(BuildContext context) => context.confirmAction(
        fn: () => context
            .read<ForgotPasswordtoggleCubit>()
            .toggleScreen(showForgotPasswordScreen: true),
        title: context.l10n.goBackConfirmationText,
        content: context.l10n.loseAllEditsText,
        noText: context.l10n.cancelText,
        yesText: context.l10n.goBackText,
        yesTextStyle: context.labelLarge?.apply(color: AppColors.blue),
      );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        _confirmGoBack(context);
        Future.value(false);
      },
      child: AppScaffold(
        appBar: AppBar(
          title: Text(context.l10n.changePasswordText),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(Icons.adaptive.arrow_back),
            onPressed: () {
              _confirmGoBack(context);
            },
          ),
        ),
        releaseFocus: true,
        resizeToAvoidBottomInset: true,
        body: AppConstrainedScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
          child: Column(
            children: [
              const Gap.v(AppSpacing.xxxlg * 3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const ChangePasswordForm(),
                    const Align(child: ChangePasswordButton()),
                  ].spacerBetween(height: AppSpacing.md),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
