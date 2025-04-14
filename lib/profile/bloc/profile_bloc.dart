import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, UserProfileState> {
  ProfileBloc({
    required UserRepository userRepository,
    required PostsRepository postsRepositroy,
    String? userId,
  })  : _userId = userId ?? userRepository.currentUser ?? '',
        _userRepository = userRepository,
        _postsRepository = postsRepositroy,
        super(const UserProfileState.initial()) {
    on<UserProfileSubscriptionRequested>(_onUserSubscriptionRequested);
    on<UserProfilePostsCountSubscriptionRequested>(_onPostsCountRequested);
    on<UserProfileFollowersCountSubscriptionRequested>(
        _onUserFollowersCountRequested);
    on<UserProfileFollowingsCountSubscriptionRequested>(
        _onUserFollowingsCountRequested);
    on<UserProfileFollowUserRequested>(_onUserFollowUserRequested);
  }

  final UserRepository _userRepository;
  final String _userId;
  final PostsRepository _postsRepository;

  Future<void> _onUserFollowUserRequested(UserProfileFollowUserRequested event,
      Emitter<UserProfileState> emit) async {
    try {
      await _userRepository.follow(followId: event.userId ?? _userId);
    } catch (e, str) {
      addError(e, str);
    }
  }

  Stream<bool> followingStatus({String? userId}) =>
      _userRepository.followingStatus(userId: _userId).asBroadcastStream();

  bool get isOwner => _userId == _userRepository.currentUser;
  Future<void> _onUserSubscriptionRequested(
    UserProfileSubscriptionRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    await emit.forEach(
      isOwner ? _userRepository.user : _userRepository.profile(id: _userId),
      onData: (user) => state.copyWith(user: user),
    );
  }

  Future<void> _onPostsCountRequested(
    UserProfilePostsCountSubscriptionRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    await emit.forEach(
      _postsRepository.postsCount(userId: _userId),
      onData: (data) => state.copyWith(postsCount: data),
    );
  }

  Future<void> _onUserFollowersCountRequested(
    UserProfileFollowersCountSubscriptionRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    await emit.forEach(
      _userRepository.followersCount(userId: _userId),
      onData: (data) => state.copyWith(followersCount: data),
    );
  }

  Future<void> _onUserFollowingsCountRequested(
    UserProfileFollowingsCountSubscriptionRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    await emit.forEach(
      _userRepository.followingsCount(userId: _userId),
      onData: (data) => state.copyWith(followingsCount: data),
    );
  }
}
