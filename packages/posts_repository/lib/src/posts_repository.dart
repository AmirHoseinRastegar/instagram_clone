// ignore_for_file: public_member_api_docs

import 'package:database_client/database_client.dart';

/// {@template posts_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class PostsRepository extends PostRepo {
  /// {@macro posts_repository}
  const PostsRepository({required this.databaseClient});
  final DatabaseClient databaseClient;
  @override
  Stream<int> postsCount({required String userId}) =>
      databaseClient.postsCount(userId: userId);
}
