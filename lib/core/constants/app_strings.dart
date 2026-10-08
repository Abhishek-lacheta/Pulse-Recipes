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
  static const String dontHaveAccount = "Don't have an account? ";
  static const String signUp = 'Sign Up';

  // Signup Screen
  static const String createAccount = 'Create Account';
  static const String signUpSubtitle = 'Sign up to get started with your account';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String confirmPasswordHint = 'Re-enter your password';
  static const String alreadyHaveAccount = 'Already have an account? ';

  // Home Screen
  static const String dashboard = 'Dashboard';
  static const String welcomeUser = 'Welcome back,';
  static const String signOut = 'Sign Out';
  static const String authStatus = 'Firebase Authentication Active';
  static const String guestUser = 'User';

  // Validation
  static const String emailRequired = 'Please enter your email';
  static const String emailInvalid = 'Please enter a valid email address';
  static const String passwordRequired = 'Please enter your password';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String confirmPasswordRequired = 'Please confirm your password';
  static const String passwordsDoNotMatch = 'Passwords do not match';
}
