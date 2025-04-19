import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:env/env.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:instagram_clone/app/di/di.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync_repository/powersync.dart';
import 'package:shared/shared.dart';

typedef AppBuilder = FutureOr<Widget> Function(
  PowerSyncRepository,
);

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

typedef EnvValue = String Function(Env);
Future<void> bootstrap(
  AppBuilder builder,
  FirebaseOptions options,
  AppFlavor appFlavor,
) async {
  FlutterError.onError = (details) {
    logD(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here

  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    initializeDependencies(appFlavor: appFlavor);
    await Firebase.initializeApp(options: options);
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory(),
    );
    // Initialize date formatting for the default locale
    await initializeDateFormatting('en');

    final powerSyncRepository = PowerSyncRepository(
      env: appFlavor.getEnv,
    );
    await powerSyncRepository.initialize();

    runApp(await builder(powerSyncRepository));
  }, (error, stack) {
    logE(error.toString(), stackTrace: stack);
  });
}
