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
