import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, UserProfileState> {
  ProfileBloc({
    required UserRepository userRepository,
    String? userId,
  })  : _userId = userId ?? userRepository.currentUser ?? '',
        _userRepository = userRepository,
        super(const UserProfileState.initial()) {
    on<UserProfileSubscriptionRequested>(_onUserSubscriptionRequested);
  }
  final UserRepository _userRepository;
  final String _userId;

  bool get isOwner => _userId == _userRepository.currentUser;
  Future<void> _onUserSubscriptionRequested(
    UserProfileSubscriptionRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    await emit.forEach(
      isOwner ? _userRepository.user : _userRepository.profile(),
      onData: (user) => state.copyWith(user: user),
    );
  }
}
