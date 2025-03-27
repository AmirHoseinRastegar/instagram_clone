import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/auth/login/login.dart';
import 'package:instagram_clone/l10n/l10n.dart';
import 'package:shared/shared.dart';
import 'package:ui/ui.dart';

class LoginEmailTextField extends StatefulWidget {
  const LoginEmailTextField({super.key});

  @override
  State<LoginEmailTextField> createState() => _LoginEmailTextFieldState();
}

class _LoginEmailTextFieldState extends State<LoginEmailTextField> {
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
      context.read<LoginCubit>().onEmailUnfocused();
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
        context.select((LoginCubit cubit) => cubit.state.email.errorMessage);
    return AppTextField(
      filled: true,
      errorText: errorMessage,
      focusNode: _focusNode,
      textController: _controller,
      hintText: context.l10n.emailText,
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.emailAddress,
      onChanged: (value) => _debouncer.run(
        () {
          context.read<LoginCubit>().onEmailChanged(value);
        },
      ),
    );
  }
}
