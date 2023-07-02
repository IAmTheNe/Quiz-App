part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.phone = const PhoneNumber.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.code = const CountryCode(
      name: 'Viet Nam',
      code: 'VN',
      dialCode: '+84',
    ),
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final PhoneNumber phone;
  final FormzSubmissionStatus status;
  final bool isValid;
  final CountryCode code;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        email,
        password,
        status,
        isValid,
        errorMessage,
        code,
        phone,
      ];

  LoginState copyWith({
    Email? email,
    Password? password,
    PhoneNumber? phone,
    FormzSubmissionStatus? status,
    bool? isValid,
    CountryCode? code,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      code: code ?? this.code,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
