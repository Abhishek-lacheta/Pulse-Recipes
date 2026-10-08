import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../firebase/auth/auth_repository.dart';
import 'auth_state.dart';

export 'auth_state.dart';

/// Cubit managing presentation authentication states and executing business logic.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthInitial()) {
    _initAuthListener();
  }

  final AuthRepository _authRepository;
  StreamSubscription? _authSubscription;

  void _initAuthListener() {
    _authSubscription = _authRepository.authStateChanges.listen((authUser) {
      if (authUser != null) {
        if (state is! AuthAuthenticated || (state as AuthAuthenticated).user != authUser) {
          emit(AuthAuthenticated(authUser));
        }
      } else {
        if (state is! AuthInitial && state is! AuthUnauthenticated && state is! AuthLoading) {
          emit(const AuthUnauthenticated());
        }
      }
    });
  }

  /// Synchronously or initially checks the authenticated session.
  void checkAuthStatus() {
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  /// Handles email and password sign-in.
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading(message: 'Signing in...'));
    try {
      final user = await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );
      emit(AuthSuccess(message: 'Signed in successfully!', user: user));
      emit(AuthAuthenticated(user));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Handles email and password registration.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading(message: 'Creating your account...'));
    try {
      final user = await _authRepository.signUpWithEmail(
        email: email,
        password: password,
      );
      emit(AuthSuccess(message: 'Account created successfully!', user: user));
      emit(AuthAuthenticated(user));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Handles Google Sign-In.
  Future<void> signInWithGoogle() async {
    emit(const AuthLoading(message: 'Connecting to Google...'));
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        emit(AuthSuccess(message: 'Signed in with Google!', user: user));
        emit(AuthAuthenticated(user));
      } else {
        // User cancelled the prompt
        final currentUser = _authRepository.currentUser;
        if (currentUser != null) {
          emit(AuthAuthenticated(currentUser));
        } else {
          emit(const AuthUnauthenticated());
        }
      }
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Signs the user out.
  Future<void> signOut() async {
    emit(const AuthLoading(message: 'Signing out...'));
    try {
      await _authRepository.signOut();
      emit(const AuthSuccess(message: 'Signed out successfully.'));
      emit(const AuthUnauthenticated());
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
