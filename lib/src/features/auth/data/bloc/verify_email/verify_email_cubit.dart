import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/features/auth/data/repositories/auth_repository.dart';

part 'verify_email_state.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  VerifyEmailCubit(this._authenticationRepository)
      : super(const VerifyEmailState());

  final AuthenticationRepository _authenticationRepository;

  Future<bool> get isEmailVerified async =>
      await _authenticationRepository.emailVerified;

  void sendEmailVerified() async {
    await _authenticationRepository.sendEmailVerification();
  }

  void checkEmailVerified() async {
    emit(
      VerifyEmailState(
          isVerified: await _authenticationRepository.emailVerified),
    );
  }

  void cancel() async {
    await _authenticationRepository.logout();
  }
}
