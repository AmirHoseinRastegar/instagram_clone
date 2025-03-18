import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';

final locator = GetIt.instance;

void initializeDependencies({required AppFlavor appFlavor}) {
  locator.registerSingleton(appFlavor);
}
