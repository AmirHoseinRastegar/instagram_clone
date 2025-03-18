import 'package:instagram_clone/app/app.dart';
import 'package:instagram_clone/bootstrap.dart';
import 'package:instagram_clone/firebase_options.dart';
import 'package:shared/shared.dart';

void main() {
  bootstrap(
    (powerSyncRepository) {
      return const App();
    },
    DefaultFirebaseOptions.currentPlatform,
    AppFlavor.development(),
  );
}
