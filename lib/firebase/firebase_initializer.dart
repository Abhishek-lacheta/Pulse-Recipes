import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../firebase_options.dart';

/// Handles isolated Firebase and Google Sign-In initialization prior to `runApp()`.
class FirebaseInitializer {
  FirebaseInitializer._();

  /// Initializes Firebase and related platform services.
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e, stackTrace) {
      debugPrint('Firebase Core initialization error: $e\n$stackTrace');
      rethrow;
    }

    try {
      await GoogleSignIn.instance.initialize();
    } catch (e, stackTrace) {
      debugPrint('Google Sign-In initialization error: $e\n$stackTrace');
    }
  }
}
