import 'dart:io';

import 'package:auth_client/auth_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:forms/forms.dart';
import 'package:powersync_repository/powersync.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';
part 'sign_up_state.dart';

/// {@template sign_up_cubit}
/// Cubit for sign up state management. It is used to change signup state from
/// initial to in progress, success or error. It also validates email, password,
/// name, surname and phone number fields.
/// {@endtemplate}
class SignUpCubit extends Cubit<SignupState> {
  /// {@macro sign_up_cubit}
  SignUpCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const SignupState.initial());

  final UserRepository _userRepository;

  /// Changes password visibility, making it visible or not.
  void changePasswordVisibility() => emit(
        state.copyWith(showPassword: !state.showPassword),
      );

  /// Emits initial state of signup screen. It is used to reset state.
  void resetState() => emit(const SignupState.initial());

  /// [Email] value was changed, triggering new changes in state. Checking
  /// whether or not value is valid in [Email] and emmiting new [Email]
  /// validation state.
  void onEmailChanged(String newValue) {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final shouldValidate = previousEmailState.invalid;
    final newEmailState = shouldValidate
        ? Email.dirty(
            newValue,
          )
        : Email.pure(
            newValue,
          );

    final newScreenState = state.copyWith(
      email: newEmailState,
    );

    emit(newScreenState);
  }

  /// [Email] field was unfocused, here is checking if previous state
  /// with [Email] was valid, in order to indicate it in state after unfocus.
  void onEmailUnfocused() {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final previousEmailValue = previousEmailState.value;

    final newEmailState = Email.dirty(
      previousEmailValue,
    );
    final newScreenState = previousScreenState.copyWith(
      email: newEmailState,
    );
    emit(newScreenState);
  }

  /// [Password] value was changed, triggering new changes in state. Checking
  /// whether or not value is valid in [Password] and emmiting new [Password]
  /// validation state.
  void onPasswordChanged(String newValue) {
    final previousScreenState = state;
    final previousPasswordState = previousScreenState.password;
    final shouldValidate = previousPasswordState.invalid;
    final newPasswordState = shouldValidate
        ? Password.dirty(
            newValue,
          )
        : Password.pure(
            newValue,
          );

    final newScreenState = state.copyWith(
      password: newPasswordState,
    );

    emit(newScreenState);
  }

  void onPasswordUnfocused() {
    final previousScreenState = state;
    final previousPasswordState = previousScreenState.password;
    final previousPasswordValue = previousPasswordState.value;

    final newPasswordState = Password.dirty(
      previousPasswordValue,
    );
    final newScreenState = previousScreenState.copyWith(
      password: newPasswordState,
    );
    emit(newScreenState);
  }

  /// [FullName] value was changed, triggering new changes in state. Checking
  /// whether or not value is valid in [FullName] and emmiting new [FullName]
  /// validation state.
  void onFullNameChanged(String newValue) {
    final previousScreenState = state;
    final previousFullNameState = previousScreenState.fullName;
    final shouldValidate = previousFullNameState.invalid;
    final newFullNameState = shouldValidate
        ? FullName.dirty(
            newValue,
          )
        : FullName.pure(
            newValue,
          );

    final newScreenState = state.copyWith(
      fullName: newFullNameState,
    );

    emit(newScreenState);
  }

  /// [FullName] field was unfocused, here is checking if previous state with
  /// [FullName] was valid, in order to indicate it in state after unfocus.
  void onFullNameUnfocused() {
    final previousScreenState = state;
    final previousFullNameState = previousScreenState.fullName;
    final previousFullNameValue = previousFullNameState.value;

    final newFullNameState = FullName.dirty(
      previousFullNameValue,
    );
    final newScreenState = previousScreenState.copyWith(
      fullName: newFullNameState,
    );
    emit(newScreenState);
  }

  /// [Username] value was changed, triggering new changes in state. Checking
  /// whether or not value is valid in [Username] and emmiting new [Username]
  /// validation state.
  void onUsernameChanged(String newValue) {
    final previousScreenState = state;
    final previousUsernameState = previousScreenState.username;
    final shouldValidate = previousUsernameState.invalid;
    final newSurnameState = shouldValidate
        ? Username.dirty(
            newValue,
          )
        : Username.pure(
            newValue,
          );

    final newScreenState = state.copyWith(
      username: newSurnameState,
    );

    emit(newScreenState);
  }

  void onUsernameUnfocused() {
    final previousScreenState = state;
    final previousUsernameState = previousScreenState.username;
    final previousUsernameValue = previousUsernameState.value;

    final newUsernameState = Username.dirty(
      previousUsernameValue,
    );
    final newScreenState = previousScreenState.copyWith(
      username: newUsernameState,
    );
    emit(newScreenState);
  }

  Future<void> onSubmit(File? file) async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final fullName = FullName.dirty(state.fullName.value);
    final userName = Username.dirty(state.username.value);
    final isValid =
        FormzValid([email, password, fullName, userName]).isFormValid;

    final newState = state.copyWith(
      email: email,
      password: password,
      username: userName,
      fullName: fullName,
      submissionStatus: isValid ? SignUpSubmissionStatus.inProgress : null,
    );
    emit(newState);
    if (!isValid) return;
    try {
      await _userRepository.signUpWithPassword(
        password: password.value,
        fullName: fullName.value,
        username: userName.value,
        email: email.value,
      );
      if (isClosed) return;
      final newState =
          state.copyWith(submissionStatus: SignUpSubmissionStatus.success);
      emit(
        newState,
      );
    } catch (e, str) {
      print('Caught error:------------------------------------------ $e');
      _errorFormatter(e, str);
    }
  }

  /// Defines method to submit form. It is used to check if all inputs are valid
  /// and if so, it is used to signup user.

  /// Defines method to format error. It is used to format error in order to
  /// show it to user.
  void _errorFormatter(Object e, StackTrace stackTrace) {
    addError(e, stackTrace);

    final submissionStatus = switch (e) {
      SignUpWithPasswordFailure(:final AuthException error) => switch (
            error.statusCode?.parse) {
          HttpStatus.badRequest ||
          HttpStatus.unprocessableEntity =>
            SignUpSubmissionStatus.emailAlreadyRegistered,
          _ => SignUpSubmissionStatus.error,
        },
      _ => SignUpSubmissionStatus.idle
    };
    final newState = state.copyWith(
      submissionStatus: submissionStatus,
    );
    emit(newState);
  }
}
