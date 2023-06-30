class SignInWithGoogleException implements Exception {
  const SignInWithGoogleException(
      [this.message = 'An unknown exception occurred.']);

  final String message;

  factory SignInWithGoogleException.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const SignInWithGoogleException(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const SignInWithGoogleException(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const SignInWithGoogleException(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const SignInWithGoogleException(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const SignInWithGoogleException(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const SignInWithGoogleException(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const SignInWithGoogleException(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const SignInWithGoogleException(
          'The credential verification ID received is invalid.',
        );
      default:
        return const SignInWithGoogleException();
    }
  }
}

class SignInWithEmailAndPasswordException implements Exception {
  const SignInWithEmailAndPasswordException(
      [this.message = 'An unknown exception occurred.']);

  final String message;

  factory SignInWithEmailAndPasswordException.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignInWithEmailAndPasswordException(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignInWithEmailAndPasswordException(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const SignInWithEmailAndPasswordException(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const SignInWithEmailAndPasswordException(
          'Incorrect password, please try again.',
        );
      default:
        return const SignInWithEmailAndPasswordException();
    }
  }
}

class LogoutException implements Exception {}

class SignUpWithEmailAndPasswordException implements Exception {
  const SignUpWithEmailAndPasswordException([
    this.message = 'An unknown exception occurred.',
  ]);

  /// The associated error message.
  final String message;

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
  factory SignUpWithEmailAndPasswordException.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordException(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordException(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordException(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordException(
          'Operation is not allowed. Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordException(
          'Please enter a stronger password.',
        );
      default:
        return const SignUpWithEmailAndPasswordException();
    }
  }
}

class PasswordResetEmailException implements Exception {
  const PasswordResetEmailException(
      [this.message = 'An unknown exception occurred.']);

  final String message;

  factory PasswordResetEmailException.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const PasswordResetEmailException(
          'Email is not valid or badly formatted.',
        );
      case 'missing-android-pkg-name':
        return const PasswordResetEmailException(
          'An Android package name must be provided if the Android app is required to be installed.',
        );
      case 'missing-continue-uri':
        return const PasswordResetEmailException(
          'A continue URL must be provided in the request.',
        );
      case 'missing-ios-bundle-id':
        return const PasswordResetEmailException(
          'An iOS Bundle ID must be provided if an App Store ID is provided.',
        );
      case 'invalid-continue-uri':
        return const PasswordResetEmailException(
          'The continue URL provided in the request is invalid.',
        );
      case 'unauthorized-continue-uri':
        return const PasswordResetEmailException(
          'The domain of the continue URL is not whitelisted. Whitelist the domain in the Firebase console.',
        );
      case 'user-not-found':
        return const PasswordResetEmailException(
          'Email is not found, please create an account.',
        );
      default:
        return const PasswordResetEmailException();
    }
  }
}
