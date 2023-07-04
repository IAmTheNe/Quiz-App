import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:whizz/src/features/auth/data/exceptions/auth_exception.dart';
import 'package:whizz/src/features/auth/data/models/otp.dart';
import 'package:whizz/src/features/auth/data/repositories/auth_repository.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit(this._authenticationRepository) : super(const OtpState());

  final AuthenticationRepository _authenticationRepository;

  void pinChanged(String value) {
    final pin = Otp.dirty(value);
    emit(
      state.copyWith(
        otp: pin,
        isValid: Formz.validate([pin]),
      ),
    );
  }

  Future<void> verifyOtp({
    required String otp,
    required String verificationId,
  }) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.verifyOtp(
        verificationId,
        otp,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on VerifyOtpException catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      state.copyWith(
        status: FormzSubmissionStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }
}
