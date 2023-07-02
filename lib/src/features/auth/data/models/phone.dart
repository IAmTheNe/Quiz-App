import 'package:formz/formz.dart';

enum PhoneValidationError { invalid }

class PhoneNumber extends FormzInput<String, PhoneValidationError> {
  const PhoneNumber.dirty([super.value = '']) : super.dirty();

  const PhoneNumber.pure() : super.pure('');

  static final _phoneRegrex = RegExp(r'^(0[35789]|01[2689])[0-9]{8}$');

  @override
  PhoneValidationError? validator(String? value) {
    return _phoneRegrex.hasMatch(value ?? '')
        ? null
        : PhoneValidationError.invalid;
  }
}
