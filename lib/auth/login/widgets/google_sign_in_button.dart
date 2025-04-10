import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/auth/login/login.dart';
import 'package:instagram_clone/l10n/l10n.dart';
import 'package:shared/shared.dart';
import 'package:ui/ui.dart';

class AuthProviderSignInButton extends StatelessWidget {
  const AuthProviderSignInButton({
    required this.provider,
    required this.onPressed,
    super.key,
  });

  final AuthProvider provider;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select(
      (LoginCubit cubit) => switch (provider) {
        AuthProvider.google => cubit.state.status.isGoogleAuthInProgress,
        AuthProvider.github => cubit.state.status.isGithubAuthInProgress,
      },
    );
    final effectiveIcon = switch (provider) {
      AuthProvider.github => Assets.icons.github.svg(),
      AuthProvider.google => Assets.icons.google.svg(),
    };
    final icon = SizedBox.square(
      dimension: 24,
      child: effectiveIcon,
    );
    return Container(
      constraints: BoxConstraints(
        minWidth: switch (context.screenWidth) {
          > 600 => context.screenWidth * .6,
          _ => context.screenWidth,
        },
      ),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Tappable.faded(
        throttle: true,
        throttleDuration: 650.ms,
        backgroundColor: context.theme.focusColor,
        borderRadius: BorderRadius.circular(4),
        onTap: isInProgress ? null : onPressed,
        child: isInProgress
            ? const Center(child: AppLoadingIndeterminate())
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: icon),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: Text(
                        context.l10n.signInWithText(provider.value),
                        style: context.labelLarge?.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

enum AuthProvider {
  github('Github'),
  google('Google');

  const AuthProvider(this.value);

  final String value;
}
