import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/app/app.dart';
import 'package:instagram_clone/app/bloc/app_bloc.dart';
import 'package:instagram_clone/l10n/arb/app_localizations.dart';
import 'package:instagram_clone/selector/selector.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:shared/shared.dart';
import 'package:ui/ui.dart';
import 'package:user_repository/user_repository.dart';

final snackbarKey = GlobalKey<AppSnackbarState>();

class AppView extends StatelessWidget {
  const AppView({
    required this.postsRepository,
    required this.userRepository,
    required this.user,
    super.key,
  });

  final UserRepository userRepository;
  final User user;
  final PostsRepository postsRepository;
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: userRepository,
        ),
        RepositoryProvider.value(
          value: postsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AppBloc(user: user, userRepository: userRepository),
          ),
          BlocProvider(
            create: (context) => ThemeBloc(),
          ),
          BlocProvider(
            create: (context) => LocaleBloc(),
          ),
        ],
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
    final routerConfig = router(context.read<AppBloc>());
    return BlocBuilder<LocaleBloc, Locale>(
      builder: (context, locale) {
        return BlocBuilder<ThemeBloc, ThemeMode>(
          builder: (context, themeMode) {
            return AnimatedSwitcher(
              duration: 350.ms,
              child: MediaQuery(
                ///for not allowing changing font size
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.noScaling,
                ),
                child: MaterialApp.router(
                  locale: locale,
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
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  debugShowCheckedModeBanner: false,
                  title: 'Instagram clone',
                  themeMode: themeMode,
                  theme: const AppTheme().theme,
                  darkTheme: const AppDarkTheme().theme,
                  routerConfig: routerConfig,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
