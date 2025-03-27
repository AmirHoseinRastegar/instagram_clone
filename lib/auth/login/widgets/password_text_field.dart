import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/auth/login/login.dart';
import 'package:instagram_clone/l10n/l10n.dart';
import 'package:shared/shared.dart';
import 'package:ui/ui.dart';

class LoginPasswordTextField extends StatefulWidget {
  const LoginPasswordTextField({super.key});

  @override
  State<LoginPasswordTextField> createState() => _LoginPasswordTextFieldState();
}

class _LoginPasswordTextFieldState extends State<LoginPasswordTextField> {
  late TextEditingController _controller;
  late Debouncer _debouncer;
  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode()..addListener(_focuseListener);
    _debouncer = Debouncer();
  }

  void _focuseListener() {
    if (!_focusNode.hasFocus) {
      context.read<LoginCubit>().onPasswordUnfocused();
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_focuseListener)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorMessage =
        context.select((LoginCubit cubit) => cubit.state.password.errorMessage);
    final passwordVisibility = context.select(
      (LoginCubit cubit) => cubit.state.showPassword,
    );
    return AppTextField(
      obscureText: !passwordVisibility,
      filled: true,
      suffixIcon: Tappable.faded(
        backgroundColor: AppColors.transparent,
        onTap: context.read<LoginCubit>().toggleShowPassword,
        child: Icon(
          passwordVisibility ? Icons.visibility_off : Icons.visibility,
          color: context.customAdaptiveColor(light: AppColors.grey),
        ),
      ),
      errorText: errorMessage,
      focusNode: _focusNode,
      textController: _controller,
      hintText: context.l10n.passwordText,
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.visiblePassword,
      onChanged: (value) => _debouncer.run(
        () {
          context.read<LoginCubit>().onPasswordChanged(value);
        },
      ),
    );
  }
}
