import 'package:flutter/material.dart';
import 'package:instagram_clone/auth/login/login.dart';
import 'package:ui/ui.dart';

class LoginInputForm extends StatelessWidget {
  const LoginInputForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
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
    );
  }
}
