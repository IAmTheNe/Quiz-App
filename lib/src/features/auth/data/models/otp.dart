import 'package:formz/formz.dart';

enum OtpValidationError { invalid }

class Otp extends FormzInput<String, OtpValidationError> {
  const Otp.dirty([super.value = '']) : super.dirty();

  const Otp.pure() : super.pure('');

  @override
  OtpValidationError? validator(String? value) {
    return value?.length == 6 ? null : OtpValidationError.invalid;
  }
}
