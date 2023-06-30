import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:whizz/src/features/auth/data/exceptions/auth_exception.dart';
import 'package:whizz/src/features/auth/data/models/email.dart';
import 'package:whizz/src/features/auth/data/repositories/auth_repository.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._authenticationRepository)
      : super(const ResetPasswordState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email]),
      ),
    );
  }

  Future<void> sendPasswordResetEmail() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.sendPasswordResetEmail(state.email.value);
      emit(
        state.copyWith(status: FormzSubmissionStatus.success),
      );
    } on PasswordResetEmailException catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzSubmissionStatus.canceled,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.canceled,
        ),
      );
    } finally {
      emit(
        state.copyWith(status: FormzSubmissionStatus.initial),
      );
    }
  }
}
