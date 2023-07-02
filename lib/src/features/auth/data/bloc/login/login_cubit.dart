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
        code: value,
      ),
    );
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.loginWithGoogle();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignInWithGoogleException catch (e) {
      emit(state.copyWith(
          errorMessage: e.message, status: FormzSubmissionStatus.failure));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  Future<void> signOut() async {
    await _authenticationRepository.logout();
  }

  Future<void> loginWithPhone({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    await _authenticationRepository.loginWithPhone(
      context,
      phoneNumber,
    );

    emit(state.copyWith(status: FormzSubmissionStatus.success));
  }

  Future<void> verifyOtp({
    required String otp,
    required String verificationId,
  }) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    await _authenticationRepository.verifyOtp(
      verificationId,
      otp,
    );

    emit(state.copyWith(status: FormzSubmissionStatus.success));
  }
}
