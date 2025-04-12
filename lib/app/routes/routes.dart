import 'dart:async';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/app/app.dart';
import 'package:instagram_clone/auth/view/auth_view.dart';
import 'package:instagram_clone/home/home.dart';
import 'package:instagram_clone/profile/view/profile_view.dart';
import 'package:ui/ui.dart';

final _rootNavKey = GlobalKey<NavigatorState>(debugLabel: 'root');
GoRouter router(AppBloc appBloc) {
  return GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: '/auth',
    routes: [
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthPage(),
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavKey,
        builder: (context, state, navigationShell) {
          return HomePage(navShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/feed',
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    child: const AppScaffold(body: Text('feed')),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return SharedAxisTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.horizontal,
                        child: child,
                      );
                    },
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/time_line',
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    child: const AppScaffold(body: Text('time line')),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return FadeTransition(
                        opacity: CurveTween(curve: Curves.easeInOut).animate(
                          animation,
                        ),
                        child: child,
                      );
                    },
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/create_media',
                redirect: (context, state) => null,
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reels',
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    child: const AppScaffold(body: Text('reels')),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return FadeTransition(
                        opacity: CurveTween(curve: Curves.easeInOut).animate(
                          animation,
                        ),
                        child: child,
                      );
                    },
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) {
                  final user =
                      context.select((AppBloc bloc) => bloc.state.user);
                  return CustomTransitionPage(
                    child: AppScaffold(
                      body: ProfilePage(
                        userId: user.id,
                      ),
                      // body: ElevatedButton(
                      //   onPressed: () {
                      //     context.read<AppBloc>().add(
                      //           const AppLogoutRequested(),
                      //         );
                      //   },
                      //   child: const Text('log out'),
                      // ),
                    ),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      return SharedAxisTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.horizontal,
                        child: child,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
    refreshListenable: GoRouterAppBlocRefreshStream(appBloc.stream),
    redirect: (context, state) {
      final authenticated = appBloc.state.status == AppStatus.authenticated;
      final authenticating = state.matchedLocation == '/auth';
      final inFeed = state.matchedLocation == '/feed';
      if (inFeed && !authenticated) return '/auth';
      if (!authenticated) return '/auth';
      if (authenticating && authenticated) return '/feed';
      return null;
    },
  );
}

/// {@template go_router_refresh_stream}
/// A [ChangeNotifier] that notifies listeners when a [Stream] emits a value.
/// This is used to rebuild the UI when the [AppBloc] emits a new state.
/// {@endtemplate}
class GoRouterAppBlocRefreshStream extends ChangeNotifier {
  /// {@macro go_router_refresh_stream}
  GoRouterAppBlocRefreshStream(Stream<AppState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((appState) {
      if (appState == _appState) return;
      _appState = appState;
      notifyListeners();
    });
  }
  AppState _appState = const AppState.unauthenticated();
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
