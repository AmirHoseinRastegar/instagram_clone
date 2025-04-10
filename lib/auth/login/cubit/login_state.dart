part of 'login_cubit.dart';

typedef LoginErrorMessage = String;

/// [LoginState] submission status, indicating current state of user login
/// process.
enum LogInSubmissionStatus {
  /// [LogInSubmissionStatus.idle] indicates that user has not yet submitted
  /// login form.
  idle,

  /// [LogInSubmissionStatus.loading] indicates that user has submitted
  /// login form and is currently waiting for response from backend.
  loading,

  /// [LogInSubmissionStatus.googleAuthInProgress] indicates that user has
  /// submitted login with google.
  googleAuthInProgress,

  /// [LogInSubmissionStatus.githubAuthInProgress] indicates that user has
  /// submitted login with github.
  githubAuthInProgress,

  /// [LogInSubmissionStatus.success] indicates that user has successfully
  /// submitted login form and is currently waiting for response from backend.
  success,

  /// [LogInSubmissionStatus.invalidCredentials] indicates that user has
  /// submitted login form with invalid credentials.
  invalidCredentials,

  /// [LogInSubmissionStatus.userNotFound] indicates that user with provided
  /// credentials was not found in database.
  userNotFound,

  /// [LogInSubmissionStatus.loading] indicates that user has no internet
  /// connection,during network request.
  networkError,

  /// [LogInSubmissionStatus.error] indicates that something unexpected happen.
  error,

  /// [LogInSubmissionStatus.googleLogInFailure] indicates that some went
  /// wrong during google login process.
  googleLogInFailure;

  bool get isSuccess => this == LogInSubmissionStatus.success;
  bool get isLoading => this == LogInSubmissionStatus.loading;
  bool get isGoogleAuthInProgress =>
      this == LogInSubmissionStatus.googleAuthInProgress;
  bool get isGithubAuthInProgress =>
      this == LogInSubmissionStatus.githubAuthInProgress;
  bool get isInvalidCredentials =>
      this == LogInSubmissionStatus.invalidCredentials;
  bool get isNetworkError => this == LogInSubmissionStatus.networkError;
  bool get isUserNotFound => this == LogInSubmissionStatus.userNotFound;
  bool get isError =>
      this == LogInSubmissionStatus.error ||
      isUserNotFound ||
      isNetworkError ||
      isInvalidCredentials;
}

class LoginState extends Equatable {
  const LoginState._({
    required this.status,
    required this.email,
    required this.password,
    this.showPassword = false,
    this.message,
  });

  ///in initial state the email and password should be pure which means
  /// unvalidated state
  const LoginState.initial()
      : this._(
          status: LogInSubmissionStatus.idle,
          email: const Email.pure(),
          password: const Password.pure(),
          showPassword: false,
        );

  final LogInSubmissionStatus status;
  final LoginErrorMessage? message;
  final bool showPassword;
  final Email email;
  final Password password;

  @override
  List<Object?> get props => [email, status, password, showPassword,message];

  LoginState copyWith({
    bool? showPassword,
    Email? email,
    String? message,
    Password? password,
    LogInSubmissionStatus? status,
  }) {
    return LoginState._(
      message: message ?? this.message,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      showPassword: showPassword ?? this.showPassword,
    );
  }
}

final loginSubmissionStatusMessage =
    <LogInSubmissionStatus, SubmissionStatusMessage>{
  LogInSubmissionStatus.error: const SubmissionStatusMessage.genericError(),
  LogInSubmissionStatus.networkError:
      const SubmissionStatusMessage.networkError(),
  LogInSubmissionStatus.invalidCredentials: const SubmissionStatusMessage(
    title: 'Email and/or password are incorrect.',
  ),
  LogInSubmissionStatus.userNotFound: const SubmissionStatusMessage(
    title: 'User with this email not found!',
    description: 'Try to sign up.',
  ),
  LogInSubmissionStatus.googleLogInFailure: const SubmissionStatusMessage(
    title: 'Google login failed!',
    description: 'Try again later.',
  ),
};
