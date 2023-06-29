part of 'verify_email_cubit.dart';

class VerifyEmailState extends Equatable {
  const VerifyEmailState({this.isVerified = false});

  final bool isVerified;

  @override
  List<Object?> get props => [isVerified];
}
