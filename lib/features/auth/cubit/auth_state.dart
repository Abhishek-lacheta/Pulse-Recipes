import 'package:equatable/equatable.dart';
import '../../../../firebase/auth/auth_user.dart';

/// Base class for all Authentication UI states.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state before authentication check begins.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State emitted while an authentication operation is in progress.
class AuthLoading extends AuthState {
  const AuthLoading({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

/// State emitted when the user is successfully authenticated.
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final AuthUser user;

  @override
  List<Object?> get props => [user];
}

/// State emitted when there is no active authenticated session.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// State emitted on successful action completion (e.g. signup, login, signout confirmation).
class AuthSuccess extends AuthState {
  const AuthSuccess({required this.message, this.user});

  final String message;
  final AuthUser? user;

  @override
  List<Object?> get props => [message, user];
}

/// State emitted when an authentication error occurs.
class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
