abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthNeedsOtp extends AuthState {
  final String email;

  AuthNeedsOtp(this.email);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
