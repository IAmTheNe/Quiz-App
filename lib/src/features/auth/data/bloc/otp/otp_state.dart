part of 'otp_cubit.dart';

class OtpState extends Equatable {
  const OtpState({
    this.otp = const Otp.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final Otp otp;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        otp,
        status,
        isValid,
        errorMessage,
      ];

  OtpState copyWith({
    Otp? otp,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return OtpState(
      otp: otp ?? this.otp,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
