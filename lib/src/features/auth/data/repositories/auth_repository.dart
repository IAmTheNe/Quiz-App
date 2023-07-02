import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:whizz/src/features/auth/data/exceptions/auth_exception.dart';
import 'package:whizz/src/features/auth/data/extensions/auth_extension.dart';
import 'package:whizz/src/features/auth/data/models/user.dart';
import 'package:whizz/src/modules/cache.dart';

class AuthenticationRepository {
  AuthenticationRepository({
    CacheClient? cache,
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.write(key: 'user', value: user);
      return user;
    });
  }

  /// Returns the current cached user.
  /// Defaults to [User.empty] if there is no cached user.
  User get currentUser {
    return _cache.read<User>(key: 'user') ?? User.empty;
  }

  /// The function `loginWithGoogle` handles the login process using Google authentication in a Flutter
  /// app, supporting both web and mobile platforms.
  Future<void> loginWithGoogle() async {
    try {
      late final firebase_auth.AuthCredential credential;
      if (kIsWeb) {
        final googleProvider = firebase_auth.GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = firebase_auth.GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        await _firebaseAuth.signInWithCredential(credential);
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInWithGoogleException(e.code);
    } catch (_) {
      throw const SignInWithGoogleException();
    }
  }

  /// The function `loginWithEmailAndPassword` attempts to sign in a user with their email and password
  /// using Firebase Authentication, and throws an exception if there is an error.
  ///
  /// Args:
  ///   email (String): A string representing the user's email address.
  ///   password (String): The password parameter is a required string that represents the user's
  /// password for authentication.
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignInWithEmailAndPasswordException.fromCode(e.code);
    } catch (_) {
      throw const SignInWithEmailAndPasswordException();
    }
  }

  /// The function `logout` signs out the user from both Firebase authentication and Google sign-in.
  Future<void> logout() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw LogoutException();
    }
  }

  /// The function `signUp` attempts to create a new user account using the provided email and password,
  /// and throws exceptions if there are any errors.
  ///
  /// Args:
  ///   email (String): A required parameter of type String that represents the email address of the
  /// user signing up.
  ///   password (String): The password parameter is a required string that represents the user's
  /// password for the sign-up process.
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordException.fromCode(e.code);
    } catch (_) {
      throw const SignInWithEmailAndPasswordException();
    }
  }

  /// The function reloads the current user's data from Firebase Authentication.
  Future<void> reload() async {
    await _firebaseAuth.currentUser?.reload();
  }

  /// The current user's email has been verified or not. Default `false`.
  bool get isEmailVerified => _firebaseAuth.currentUser?.emailVerified ?? false;

  /// The function sends an email verification to the current user if they are logged in.
  void sendEmailVerification() {
    _firebaseAuth.currentUser?.sendEmailVerification();
  }

  /// The function sends a password reset email to the specified email address using Firebase
  /// Authentication.
  ///
  /// Args:
  ///   email (String): The email parameter is a string that represents the email address of the user
  /// who wants to reset their password.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw PasswordResetEmailException.fromCode(e.code);
    } catch (_) {
      throw const PasswordResetEmailException();
    }
  }

  Future<void> loginWithPhone(String phoneNumber) async {
    _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) {
        _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (_) {},
      codeSent: (_, __) {},
      codeAutoRetrievalTimeout: (_) {},
    );
  }
}
