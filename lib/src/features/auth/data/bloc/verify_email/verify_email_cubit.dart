import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/features/auth/data/repositories/auth_repository.dart';

final class VerifyEmailCubit extends Cubit<bool> {
  VerifyEmailCubit(this._authenticationRepository)
      : super(_authenticationRepository.isEmailVerified);

  final AuthenticationRepository _authenticationRepository;

  void checkEmailVerified() {
    _authenticationRepository
        .reload()
        .then((_) => emit(_authenticationRepository.isEmailVerified));
  }

  void sendEmailVerification() {
    _authenticationRepository.sendEmailVerification();
  }

  bool get emailVerified => _authenticationRepository.isEmailVerified;

  Future<void> cancel() async {
    await _authenticationRepository.logout();
  }
}
