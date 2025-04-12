// ignore: public_member_api_docs
import 'package:powersync_repository/powersync.dart';
import 'package:user_repository/user_repository.dart';

// ignore: public_member_api_docs
abstract class UserDataClient {
  // ignore: public_member_api_docs
  UserDataClient();
  // ignore: public_member_api_docs
  String? get currentUser;
  Stream<User> profile({required String id});
}

/// {@template database_client}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
abstract class DatabaseClient extends UserDataClient {
  /// {@macro database_client}
  DatabaseClient();
}

// ignore: public_member_api_docs
class PowerSyncUserDatabaseRepository extends DatabaseClient {
  // ignore: public_member_api_docs
  PowerSyncUserDatabaseRepository({
    required PowerSyncRepository powerSyncRepository,
  }) : _powerSyncRepository = powerSyncRepository;
  final PowerSyncRepository _powerSyncRepository;

  @override
  String? get currentUser =>
      _powerSyncRepository.supabase.auth.currentSession?.user.id;

  @override
  Stream<User> profile({required String id}) => _powerSyncRepository.db().watch(
        '''
        SELECT * FROM profiles WHERE id =
        ''',
        parameters: [id],
      ).map(
        (event) => event.isEmpty ? User.anonymous : User.fromJson(event.first),
      );
}
