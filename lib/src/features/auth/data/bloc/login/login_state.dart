part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.phone = const PhoneNumber.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.countryCode = const CountryCode(
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
  final CountryCode countryCode;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        email,
        password,
        status,
        isValid,
        errorMessage,
        countryCode,
        phone,
      ];

  LoginState copyWith({
    Email? email,
    Password? password,
    PhoneNumber? phone,
    FormzSubmissionStatus? status,
    bool? isValid,
    CountryCode? countryCode,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      countryCode: countryCode ?? this.countryCode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
