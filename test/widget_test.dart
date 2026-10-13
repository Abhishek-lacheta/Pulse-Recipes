import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_recipes/core/constants/app_strings.dart';
import 'package:pulse_recipes/firebase/auth/auth_repository.dart';
import 'package:pulse_recipes/main.dart';

class FakeAuthRepository implements AuthRepository {
  final _controller = StreamController<AuthUser?>.broadcast();

  @override
  Stream<AuthUser?> get authStateChanges => _controller.stream;

  @override
  AuthUser? get currentUser => null;

  @override
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return const AuthUser(id: 'test-uid', email: 'test@example.com');
  }

  @override
  Future<AuthUser> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return const AuthUser(id: 'test-uid', email: 'test@example.com');
  }

  @override
  Future<AuthUser?> signInWithGoogle() async => null;

  @override
  Future<void> signOut() async {}
}

void main() {
  testWidgets('Splash screen loads brand name and tagline', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(authRepository: FakeAuthRepository()));

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.appTagline), findsOneWidget);
  });
}
