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

class LogoutException implements Exception {}

class VerifyPhoneNumberException implements Exception {
  const VerifyPhoneNumberException(
      [this.message = "An unknown exception occurred."]);

  final String message;

  factory VerifyPhoneNumberException.fromCode(String code) {
    switch (code) {
      case "too-many-requests":
        return const VerifyPhoneNumberException(
            'We have blocked all requests from this device due to unusual activity. Try again later.');
      default:
        return const VerifyPhoneNumberException();
    }
  }
}

class VerifyOtpException implements Exception {
  const VerifyOtpException([this.message = "An unknown exception occured."]);

  final String message;

  factory VerifyOtpException.fromCode(String code) {
    switch (code) {
      case 'invalid-verification-code':
        return const VerifyOtpException(
            'The verification code from SMS/TOTP is invalid. Please check and enter the correct verification code again.');
      default:
        return const VerifyOtpException();
    }
  }
}
