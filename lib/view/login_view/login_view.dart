import 'package:env/env.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone/app/di/di.dart';
import 'package:powersync_repository/powersync.dart';
import 'package:shared/shared.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [GoogleSignInWidget(), LogOutWidget()],
        ),
      ),
    );
  }
}

class GoogleSignInWidget extends StatelessWidget {
  const GoogleSignInWidget({super.key});

  Future<void> _signInMethod() async {
    final webClientId = locator<AppFlavor>().getEnv(Env.webClientId);
    final iosClientId = locator<AppFlavor>().getEnv(Env.iOSClientId);
    final googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;
    if (googleAuth == null) {
      throw Exception('sign in failed');
    }
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;
    if (accessToken == null) {
      throw Exception(' no accesstoken found');
    }
    if (idToken == null) {
      throw Exception(' no idtoken found');
    }
    await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        try {
          await _signInMethod();
        } catch (e, str) {
          logD('failed to sign in', error: e, stackTrace: str);
        }
      },
      icon: const Icon(Icons.auto_awesome),
      label: Text(
        'Sign in With Google',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

class LogOutWidget extends StatelessWidget {
  const LogOutWidget({super.key});
  void _logOut() => Supabase.instance.client.auth.signOut();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final session = snapshot.data!.session;
          if (session == null) {
            return const SizedBox.shrink();
          }
          return ElevatedButton.icon(
            onPressed: _logOut,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
