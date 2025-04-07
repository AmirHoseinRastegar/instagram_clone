part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}
final class UserProfileUpdateRequested extends ProfileEvent {
  const UserProfileUpdateRequested({
    this.fullName,
    this.email,
    this.username,
    this.avatarUrl,
    this.pushToken,
  });

  final String? fullName;
  final String? email;
  final String? username;
  final String? avatarUrl;
  final String? pushToken;
}

final class UserProfileSubscriptionRequested extends ProfileEvent {
  const UserProfileSubscriptionRequested({this.userId});

  final String? userId;
}

final class UserProfilePostsCountSubscriptionRequested
    extends ProfileEvent {
  const UserProfilePostsCountSubscriptionRequested();
}

final class UserProfileFollowingsCountSubscriptionRequested
    extends ProfileEvent {
  const UserProfileFollowingsCountSubscriptionRequested();
}

final class UserProfileFollowersCountSubscriptionRequested
    extends ProfileEvent {
  const UserProfileFollowersCountSubscriptionRequested();
}

final class UserProfileFetchFollowersRequested extends ProfileEvent {
  const UserProfileFetchFollowersRequested({this.userId});

  final String? userId;
}

final class UserProfileFetchFollowingsRequested extends ProfileEvent {
  const UserProfileFetchFollowingsRequested({this.userId});

  final String? userId;
}

final class UserProfileFollowersSubscriptionRequested extends ProfileEvent {
  const UserProfileFollowersSubscriptionRequested();
}

final class UserProfileFollowUserRequested extends ProfileEvent {
  const UserProfileFollowUserRequested({this.userId});

  final String? userId;
}

final class UserProfileRemoveFollowerRequested extends ProfileEvent {
  const UserProfileRemoveFollowerRequested({this.userId});

  final String? userId;
}
