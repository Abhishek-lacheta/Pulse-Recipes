import 'auth_user.dart';
import 'firebase_auth_service.dart';
import 'firebase_google_auth_service.dart';

export 'auth_exception.dart';
export 'auth_user.dart';

/// Abstract contract for authentication operations.
/// All application UI and State Management layers interact ONLY with this contract.
abstract class AuthRepository {
  /// Stream of authentication state changes.
  Stream<AuthUser?> get authStateChanges;

  /// Returns the currently authenticated user, or null if unauthenticated.
  AuthUser? get currentUser;

  /// Signs in using email and password.
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  });

  /// Registers a new account with email and password.
  Future<AuthUser> signUpWithEmail({
    required String email,
    required String password,
  });

  /// Signs in using Google authentication. Returns null if cancelled.
  Future<AuthUser?> signInWithGoogle();

  /// Logs out the user from all providers (Firebase & Google).
  Future<void> signOut();
}

/// Production implementation of [AuthRepository] backing Firebase and Google authentication.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    FirebaseAuthService? authService,
    FirebaseGoogleAuthService? googleAuthService,
  })  : _authService = authService ?? FirebaseAuthService(),
        _googleAuthService = googleAuthService ?? FirebaseGoogleAuthService();

  final FirebaseAuthService _authService;
  final FirebaseGoogleAuthService _googleAuthService;

  @override
  Stream<AuthUser?> get authStateChanges => _authService.authStateChanges;

  @override
  AuthUser? get currentUser => _authService.currentUser;

  @override
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _authService.signInWithEmail(
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthUser> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return _authService.signUpWithEmail(
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthUser?> signInWithGoogle() {
    return _googleAuthService.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _googleAuthService.signOut(),
      _authService.signOut(),
    ]);
  }
}
