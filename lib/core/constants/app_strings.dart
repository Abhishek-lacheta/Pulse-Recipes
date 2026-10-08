/// Centralized UI strings for consistency and easy internationalization.
class AppStrings {
  AppStrings._();

  static const String appName = 'Pulse';
  static const String appTagline = 'Fast, secure & seamless access';

  // Login Screen
  static const String welcomeBack = 'Welcome back';
  static const String loginSubtitle = 'Sign in to access your dashboard';
  static const String emailLabel = 'Email address';
  static const String emailHint = 'you@company.com';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String signIn = 'Sign In';
  static const String continueWithGoogle = 'Continue with Google';
  static const String orDivider = 'OR';

  // Validation
  static const String emailRequired = 'Please enter your email';
  static const String emailInvalid = 'Please enter a valid email address';
  static const String passwordRequired = 'Please enter your password';
  static const String passwordTooShort = 'Password must be at least 6 characters';
}
