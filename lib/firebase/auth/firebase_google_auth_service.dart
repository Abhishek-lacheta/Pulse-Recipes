import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_exception.dart';
import 'auth_user.dart';

/// Low-level service strictly responsible for Google Sign-In and credential linking.
class FirebaseGoogleAuthService {
  FirebaseGoogleAuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Signs in with Google account and links credential with Firebase.
  /// Returns [AuthUser] on success, or `null` if the user cancelled the dialog.
  Future<AuthUser?> signInWithGoogle() async {
    try {
      // Trigger native Google account selection dialog
      final account = await _googleSignIn.authenticate();

      final auth = account.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        throw const AuthException('Google sign-in failed: user not returned.');
      }

      return AuthUser(
        id: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuth(e);
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      // Handle user cancellation gracefully
      if (errorString.contains('cancel') || errorString.contains('canceled') || errorString.contains('cancelled')) {
        debugPrint('Google Sign-In was cancelled by user: $e');
        return null;
      }
      throw AuthException.fromGoogleSignIn(e);
    }
  }

  /// Signs out of Google session.
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Google sign-out notice: $e');
    }
  }
}
