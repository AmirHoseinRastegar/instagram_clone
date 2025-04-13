// ignore_for_file: public_member_api_docs, one_member_abstracts

import 'package:powersync_repository/powersync.dart';
import 'package:user_repository/user_repository.dart';

abstract class UserDataClient {
  UserDataClient();
  String? get currentUser;
  Stream<User> profile({required String id});
  Stream<int> followersCount({required String userId});
  Stream<int> followingsCount({required String userId});
}

abstract class PostRepo {
  const PostRepo();
  Stream<int> postsCount({required String userId});
}

/// {@template database_client}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
abstract class DatabaseClient implements UserDataClient, PostRepo {
  /// {@macro database_client}
  DatabaseClient();
}

class PowerSyncUserDatabaseRepository extends DatabaseClient {
  PowerSyncUserDatabaseRepository({
    required PowerSyncRepository powerSyncRepository,
  }) : _powerSyncRepository = powerSyncRepository;
  final PowerSyncRepository _powerSyncRepository;

  @override
  String? get currentUser =>
      _powerSyncRepository.supabase.auth.currentSession?.user.id;

  @override
  Stream<User> profile({required String id}) => _powerSyncRepository.db().watch(
        ///? mark is equal to parameter we send to it which is userId

        '''
        SELECT * FROM profiles WHERE id =
        ''',
        parameters: [id],
      ).map(
        (event) => event.isEmpty ? User.anonymous : User.fromJson(event.first),
      );

  @override
  Stream<int> postsCount({required String userId}) =>
      _powerSyncRepository.db().watch(
        ///? mark is equal to parameter we send to it which is userId
        '''
        SELECT COUNT(*) as posts_count FROM posts where user_id = ?
        ''',
        parameters: [userId],
      ).map(
        (event) => event.first['posts_count'] as int,
      );

  @override
  Stream<int> followersCount({required String userId}) =>
      _powerSyncRepository.db().watch(
        'SELECT COUNT(*) AS subscription_count FROM subscriptions '
        'WHERE subscribed_to_id = ?',
        parameters: [userId],
      ).map(
        (event) => event.first['subscription_count'] as int,
      );

  @override
  Stream<int> followingsCount({required String userId}) =>
      _powerSyncRepository.db().watch(
        'SELECT COUNT(*) AS subscription_count FROM subscriptions '
        'WHERE subscriber_id = ?',
        parameters: [userId],
      ).map(
        (event) => event.first['subscription_count'] as int,
      );
}
