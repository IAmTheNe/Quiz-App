import 'package:equatable/equatable.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:whizz/src/features/auth/data/exceptions/auth_exception.dart';
import 'package:whizz/src/features/auth/data/models/email.dart';
import 'package:whizz/src/features/auth/data/models/password.dart';
import 'package:whizz/src/features/auth/data/models/phone.dart';
import 'package:whizz/src/features/auth/data/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.email, password]),
      ),
    );
  }

  void phoneChanged(String value) {
    final phone = PhoneNumber.dirty(value);
    emit(
      state.copyWith(
        phone: phone,
        isValid: Formz.validate([phone]),
      ),
    );
  }

  void countryChanged(CountryCode value) {
    emit(
      state.copyWith(
        countryCode: value,
      ),
    );
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.loginWithGoogle();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignInWithCredentialException catch (e) {
      emit(state.copyWith(
          errorMessage: e.message, status: FormzSubmissionStatus.failure));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  Future<void> signOut() async {
    emit(const LoginState());
    await _authenticationRepository.logout();
  }

  Future<void> loginWithPhone({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.loginWithPhone(
        context,
        phoneNumber,
      );
    } on VerifyPhoneNumberException catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      state.copyWith(
        status: FormzSubmissionStatus.failure,
      );
    }

    emit(state.copyWith(status: FormzSubmissionStatus.success));
  }

  Future<void> loginWithTwitter() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.loginWithTwitter();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignInWithCredentialException catch (e) {
      emit(state.copyWith(
          errorMessage: e.message, status: FormzSubmissionStatus.failure));
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), status: FormzSubmissionStatus.failure));
    }
  }
}
