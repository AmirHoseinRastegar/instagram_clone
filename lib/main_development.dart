import 'package:database_client/database_client.dart';
import 'package:env/env.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone/app/di/di.dart';
import 'package:instagram_clone/app/view/app_view.dart';
import 'package:instagram_clone/bootstrap.dart';
import 'package:instagram_clone/firebase_options.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:shared/shared.dart';
import 'package:supabase_auth_client/supabase_auth_client.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  bootstrap(
    (powerSyncRepository) async {
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

      final dataBaseClient = PowerSyncUserDatabaseRepository(
        powerSyncRepository: powerSyncRepository,
      );

      final userRepository = UserRepository(
        authenticationClient: supabaseAuthClient,
        databaseClient: dataBaseClient,
      );
      final postsRepository = PostsRepository(databaseClient: dataBaseClient);
      return AppView(
        postsRepository: postsRepository,
        user: await userRepository.user.first,
        userRepository: userRepository,
      );
    },
    DefaultFirebaseOptions.currentPlatform,
    AppFlavor.development(),
  );
}
