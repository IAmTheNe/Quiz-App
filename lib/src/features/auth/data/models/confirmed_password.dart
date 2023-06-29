import 'package:formz/formz.dart';

enum ConfirmedPasswordValidatorError { invalid }

class ConfirmedPassword
    extends FormzInput<String, ConfirmedPasswordValidatorError> {
  const ConfirmedPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');

  /// The original password.
  final String password;

  @override
  ConfirmedPasswordValidatorError? validator(String? value) {
    return password == value ? null : ConfirmedPasswordValidatorError.invalid;
  }
}
