// ignore: public_member_api_docs
import 'package:powersync_repository/powersync.dart';

// ignore: public_member_api_docs
abstract class UserDataClient {
  // ignore: public_member_api_docs
  UserDataClient();
  // ignore: public_member_api_docs
  String? get currentUser;
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
}
