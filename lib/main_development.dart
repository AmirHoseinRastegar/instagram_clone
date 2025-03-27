import 'package:env/env.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone/app/di/di.dart';
import 'package:instagram_clone/bootstrap.dart';
import 'package:instagram_clone/firebase_options.dart';
import 'package:instagram_clone/auth/login/login.dart';
import 'package:shared/shared.dart';
import 'package:supabase_auth_client/supabase_auth_client.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  bootstrap(
    (powerSyncRepository) {
      final iOSCLIENTID = locator<AppFlavor>().getEnv(Env.iOSClientId);
      final wEBCLIENTID = locator<AppFlavor>().getEnv(Env.webClientId);
      final googleSignIn = GoogleSignIn(
        clientId: iOSCLIENTID,
        serverClientId: wEBCLIENTID,
      );
      final tokenStorage = InMemoryTokenStorage();
      print(tokenStorage.readToken().toString().toUpperCase());

      final supabaseAuthClient = SupabaseAuthenticationClient(
        googleSignIn: googleSignIn,
        powerSyncRepository: powerSyncRepository,
        tokenStorage: tokenStorage,
      );
      final userRepository = UserRepository(
        authenticationClient: supabaseAuthClient,
      );
      return AppView(
        userRepository: userRepository,
      );
    },
    DefaultFirebaseOptions.currentPlatform,
    AppFlavor.development(),
  );
}
