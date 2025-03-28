import 'package:flutter/material.dart';
import 'package:instagram_clone/auth/forgot_password/forgot_password.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ForgotPasswordEmailField(),
      ],
    );
  }
}
