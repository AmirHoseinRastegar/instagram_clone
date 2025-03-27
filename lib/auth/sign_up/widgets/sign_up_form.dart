import 'package:flutter/widgets.dart';
import 'package:instagram_clone/auth/sign_up/sign_up.dart';
import 'package:ui/ui.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
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
       
      ].spacerBetween( height:AppSpacing.md),
    );
  }
}
