import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:whizz/src/features/auth/data/exceptions/auth_exception.dart';
import 'package:whizz/src/features/auth/data/extensions/auth_extension.dart';
import 'package:whizz/src/features/auth/data/models/user.dart';
import 'package:whizz/src/modules/cache.dart';
import 'package:whizz/src/router/app_router.dart';

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

  Future<void> loginWithPhone(
    BuildContext context,
    String phoneNumber,
  ) async {
    final completer = Completer<firebase_auth.PhoneAuthCredential>();
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: completer.complete,
      verificationFailed: completer.completeError,
      codeSent: (verificationId, forceResendingToken) async {
        await context.pushNamed(
          RouterPath.otp.name,
          extra: (verificationId, forceResendingToken),
        );
      },
      codeAutoRetrievalTimeout: (_) {},
      timeout: const Duration(seconds: 60),
    );

    try {
      final credential = await completer.future;
      await _firebaseAuth.signInWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw VerifyPhoneNumberException.fromCode(e.code);
    } catch (_) {
      throw const VerifyPhoneNumberException();
    }
  }

  Future<void> verifyOtp(
    String verificationId,
    String otp,
  ) async {
    try {
      firebase_auth.PhoneAuthCredential credential =
          firebase_auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw VerifyOtpException.fromCode(e.code);
    } catch (e) {
      log(e.toString());
      throw const VerifyOtpException();
    }
  }
}
