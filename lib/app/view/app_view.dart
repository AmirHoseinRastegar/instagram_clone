import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/app/bloc/app_bloc.dart';
import 'package:instagram_clone/app/routes/routes.dart';
import 'package:instagram_clone/l10n/arb/app_localizations.dart';
import 'package:ui/ui.dart';
import 'package:user_repository/user_repository.dart';

final snackbarKey = GlobalKey<AppSnackbarState>();

class AppView extends StatelessWidget {
  const AppView({required this.userRepository, required this.user, super.key});

  final UserRepository userRepository;
  final User user;
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: userRepository,
      child: BlocProvider(
        create: (context) =>
            AppBloc(user: user, userRepository: userRepository),
        child: const App(),
      ),
    );
  }
}

/// Snack bar to show messages to the user.
void openSnackbar(
  SnackbarMessage message, {
  bool clearIfQueue = false,
  bool undismissable = false,
}) {
  snackbarKey.currentState
      ?.post(message, clearIfQueue: clearIfQueue, undismissable: undismissable);
}

/// Closes all snack bars.
void closeSnackbars() => snackbarKey.currentState?.closeAll();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            AppSnackbar(
              key: snackbarKey,
            ),
          ],
        );
      },
      localizationsDelegates: const [AppLocalizations.delegate],
      debugShowCheckedModeBanner: false,
      title: 'Instagram clone',
      themeMode: ThemeMode.light,
      theme: const AppTheme().theme,
      darkTheme: const AppDarkTheme().theme,
      routerConfig: router(
        context.read<AppBloc>(),
      ),
    );
  }
}
