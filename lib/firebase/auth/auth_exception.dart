import 'package:firebase_auth/firebase_auth.dart';

/// Exception thrown for authentication failures, providing user-friendly error messages.
class AuthException implements Exception {
  const AuthException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => message;

  /// Translates [FirebaseAuthException] into user-friendly [AuthException].
  factory AuthException.fromFirebaseAuth(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return const AuthException(
          'The email address is invalid.',
          code: 'invalid-email',
        );
      case 'user-disabled':
        return const AuthException(
          'This user account has been disabled. Please contact support.',
          code: 'user-disabled',
        );
      case 'user-not-found':
        return const AuthException(
          'No account found with this email.',
          code: 'user-not-found',
        );
      case 'wrong-password':
        return const AuthException(
          'Incorrect password. Please try again.',
          code: 'wrong-password',
        );
      case 'invalid-credential':
        return const AuthException(
          'Invalid email or password. Please verify your credentials.',
          code: 'invalid-credential',
        );
      case 'email-already-in-use':
        return const AuthException(
          'An account already exists with this email address.',
          code: 'email-already-in-use',
        );
      case 'weak-password':
        return const AuthException(
          'The password is too weak. Please use at least 6 characters.',
          code: 'weak-password',
        );
      case 'operation-not-allowed':
        return const AuthException(
          'This sign-in provider is not enabled in Firebase Console.',
          code: 'operation-not-allowed',
        );
      case 'network-request-failed':
        return const AuthException(
          'Network connection error. Please check your internet connection.',
          code: 'network-request-failed',
        );
      case 'too-many-requests':
        return const AuthException(
          'Too many failed attempts. Please try again later.',
          code: 'too-many-requests',
        );
      case 'account-exists-with-different-credential':
        return const AuthException(
          'An account already exists with the same email using different credentials.',
          code: 'account-exists-with-different-credential',
        );
      default:
        return AuthException(
          e.message ?? 'An unexpected authentication error occurred.',
          code: e.code,
        );
    }
  }

  /// Translates Google Sign-In errors into user-friendly [AuthException].
  factory AuthException.fromGoogleSignIn(Object error) {
    final str = error.toString().toLowerCase();
    if (str.contains('cancel') || str.contains('cancelled') || str.contains('status: canceled')) {
      return const AuthException(
        'Google sign-in was cancelled.',
        code: 'cancelled',
      );
    }
    if (str.contains('network') || str.contains('socketexception')) {
      return const AuthException(
        'Network error during Google sign-in. Check your connection.',
        code: 'network-error',
      );
    }
    if (str.contains('10') || str.contains('12500') || str.contains('16')) {
      return const AuthException(
        'Google Sign-In configuration error. Verify SHA-1 fingerprint in Firebase Console.',
        code: 'config-error',
      );
    }
    return AuthException(
      'Google sign-in failed. Please try again.',
      code: 'google-sign-in-failed',
    );
  }
}
