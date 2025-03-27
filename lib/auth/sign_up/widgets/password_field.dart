import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/auth/sign_up/sign_up.dart';
import 'package:instagram_clone/l10n/l10n.dart';
import 'package:shared/shared.dart';
import 'package:ui/ui.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({super.key});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  final _debouncer = Debouncer();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SignUpCubit>();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        cubit.onPasswordUnfocused();
      }
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context
        .select((SignUpCubit cubit) => cubit.state.submissionStatus.isLoading);
    final passwordError = context
        .select((SignUpCubit cubit) => cubit.state.password.errorMessage);
    final showPassword =
        context.select((SignUpCubit cubit) => cubit.state.showPassword);
    return AppTextField(
      filled: true,
      focusNode: _focusNode,
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.visiblePassword,
      autofillHints: const [AutofillHints.password],
      hintText: context.l10n.passwordText,
      enabled: !isLoading,
      obscureText: !showPassword,
      onChanged: (v) => _debouncer.run(
        () => context.read<SignUpCubit>().onPasswordChanged(v),
      ),
      errorText: passwordError,
      suffixIcon: Tappable.faded(
        backgroundColor: AppColors.transparent,
        onTap: isLoading
            ? null
            : context.read<SignUpCubit>().changePasswordVisibility,
        child: Icon(
          !showPassword ? Icons.visibility : Icons.visibility_off,
          color: context
              .customAdaptiveColor(dark: AppColors.grey)
              .withValues(alpha: (isLoading ? .4 : 1) * 255),
        ),
      ),
    );
  }
}
