import 'package:flutter_test/flutter_test.dart';
import 'package:machine_test_abhishek/core/constants/app_strings.dart';
import 'package:machine_test_abhishek/main.dart';

void main() {
  testWidgets('Splash screen loads brand name and tagline', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the brand texts exist
    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.appTagline), findsOneWidget);
  });
}
