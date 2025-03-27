import 'dart:io';

import 'package:auth_client/auth_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:forms/forms.dart';
import 'package:powersync_repository/powersync.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.userRepository,
  }) : super(const LoginState.initial());
  final UserRepository userRepository;

  Future<void> onSubmited() async {
    final emailValue = Email.dirty(state.email.value);
    final passwordValue = Password.dirty(state.password.value);
    final isValid = FormzValid([emailValue, passwordValue]).isFormValid;
    final newState = state.copyWith(
      email: emailValue,
      password: passwordValue,
      status: isValid ? LogInSubmissionStatus.loading : null,
    );
    emit(newState);
    if (!isValid) return;
    try {
      await userRepository.logInWithPassword(
        email: emailValue.value,
        password: passwordValue.value,
      );
      print(emailValue.value);
      final newState = state.copyWith(status: LogInSubmissionStatus.success);
      emit(newState);
    } catch (e, stackTrace) {
      _errorFormatter(e, stackTrace);
    }
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: LogInSubmissionStatus.googleAuthInProgress));
    try {
      await userRepository.logInWithGoogle();
      emit(state.copyWith(status: LogInSubmissionStatus.success));
    } on LogInWithGoogleCanceled {
      emit(state.copyWith(status: LogInSubmissionStatus.idle));
    } catch (error, stackTrace) {
      _errorFormatter(error, stackTrace);
    }
  }

  Future<void> loginWithGithub() async {
    emit(state.copyWith(status: LogInSubmissionStatus.githubAuthInProgress));
    try {
      await userRepository.logInWithGithub();
      emit(state.copyWith(status: LogInSubmissionStatus.success));
    } on LogInWithGithubCanceled {
      emit(state.copyWith(status: LogInSubmissionStatus.idle));
    } catch (error, stackTrace) {
      _errorFormatter(error, stackTrace);
    }
  }

  void toggleShowPassword() =>
      emit(state.copyWith(showPassword: !state.showPassword));

  void onEmailChanged(String value) {
    final currentScreenState = state;
    final emailState = currentScreenState.email;
    final needValidation = emailState.invalid;
    final newEmailState =
        needValidation ? Email.dirty(value) : Email.pure(value);
    final newScreenState = state.copyWith(
      email: newEmailState,
    );
    emit(newScreenState);
  }

  void onEmailUnfocused() {
    final previousScreenState = state;
    final previousEmailState = previousScreenState.email;
    final previousEmailValue = previousEmailState.value;
    final newEmailState = Email.dirty(previousEmailValue);

    final newScreenState = state.copyWith(email: newEmailState);
    emit(newScreenState);
  }

  void onPasswordChanged(String value) {
    final currentScreenState = state;
    final passwordState = currentScreenState.password;
    final needValidation = passwordState.invalid;
    final newPasswordState =
        needValidation ? Password.dirty(value) : Password.pure(value);
    final newScreenState = state.copyWith(
      password: newPasswordState,
    );
    emit(newScreenState);
  }

  void onPasswordUnfocused() {
    final previousScreenState = state;
    final previousPasswordState = previousScreenState.password;
    final previousPasswordValue = previousPasswordState.value;
    final newPasswordState = Password.dirty(previousPasswordValue);

    final newScreenState = state.copyWith(password: newPasswordState);
    emit(newScreenState);
  }

  /// Formats error, that occurred during login process.
  void _errorFormatter(Object e, StackTrace stackTrace) {
    addError(e, stackTrace);
    final status = switch (e) {
      LogInWithPasswordFailure(:final AuthException error) => switch (
            error.statusCode?.parse) {
          HttpStatus.badRequest => LogInSubmissionStatus.invalidCredentials,
          _ => LogInSubmissionStatus.error,
        },
      LogInWithGoogleFailure => LogInSubmissionStatus.googleLogInFailure,
      _ => LogInSubmissionStatus.idle,
    };

    final newState = state.copyWith(
      status: status,
      message: e.toString(),
    );
    emit(newState);
  }
}
