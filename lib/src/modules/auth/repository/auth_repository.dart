import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/utils/cache.dart';
import 'package:whizz/src/env/env.dart';
import 'package:whizz/src/modules/auth/exception/auth_exception.dart';
import 'package:whizz/src/modules/auth/models/user.dart';
import 'package:whizz/src/router/app_router.dart';

class AuthenticationRepository {
  AuthenticationRepository({
    InMemoryCache? cache,
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
    TwitterLogin? twitterLogin,
  })  : _cache = cache ?? InMemoryCache(),
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _twitterLogin = twitterLogin ??
            TwitterLogin(
              apiKey: Env.apiKey,
              apiSecretKey: Env.apiKeySecret,
              redirectURI: "socialauth://",
            );

  final InMemoryCache _cache;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final TwitterLogin _twitterLogin;

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<AppUser> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? AppUser.empty : firebaseUser.toUser;
      _cache.write(key: 'user', value: user);
      return user;
    });
  }

  /// Returns the current cached user.
  /// Defaults to [User.empty] if there is no cached user.
  AppUser get currentUser {
    return _cache.read<AppUser>(key: 'user') ?? AppUser.empty;
  }

  /// The function `loginWithGoogle` handles the login process using Google authentication in a Flutter
  /// app, supporting both web and mobile platforms.
  Future<void> loginWithGoogle() async {
    try {
      late final AuthCredential credential;
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        final user = await _firebaseAuth.signInWithCredential(credential);
        await _addUser(user.user!.toUser);
      }
    } on FirebaseAuthException catch (e) {
      throw SignInWithCredentialException(e.code);
    } catch (_) {
      throw const SignInWithCredentialException();
    }
  }

  Future<void> loginWithTwitter() async {
    final authResult = await _twitterLogin.loginV2();
    if (authResult.status == TwitterLoginStatus.loggedIn) {
      try {
        final credential = TwitterAuthProvider.credential(
          accessToken: authResult.authToken!,
          secret: authResult.authTokenSecret!,
        );
        final user = await _firebaseAuth.signInWithCredential(credential);
        await _addUser(user.user!.toUser);
      } on FirebaseAuthException catch (e) {
        throw SignInWithCredentialException.fromCode(e.code);
      } catch (e) {
        log(e.toString());
        throw const SignInWithCredentialException();
      }
    } else {
      throw const SignInWithCredentialException('Không login được!');
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
      // throw LogoutException();
    }
  }

  Future<void> loginWithPhoneNumber(
    BuildContext context,
    String phoneNumber,
  ) async {
    final completer = Completer<PhoneAuthCredential>();
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: completer.complete,
      verificationFailed: completer.completeError,
      codeSent: (verificationId, forceResendingToken) async {
        context.hideCurrentSnackbar();
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
    } on FirebaseAuthException catch (e) {
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
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw VerifyOtpException.fromCode(e.code);
    } catch (e) {
      log(e.toString());
      throw const VerifyOtpException();
    }
  }

  Future<void> _addUser(AppUser user) async {
    try {
      await _firestore
          .collection(FirebaseDocumentConstants.user)
          .doc(user.id)
          .set(user.toMap());
    } catch (e) {
      log(e.toString());
    }
  }
}
