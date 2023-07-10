import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:pinput/pinput.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/custom_button.dart';
import 'package:whizz/src/features/auth/data/bloc/login/login_cubit.dart';
import 'package:whizz/src/features/auth/data/bloc/otp/otp_cubit.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.codeSent});

  final (String, int) codeSent;

  void verifyPin(BuildContext context, String pin) {
    context.read<OtpCubit>().verifyOtp(
          otp: pin,
          verificationId: codeSent.$1,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            context.showErrorSnackBar(state.errorMessage!);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(Constants.kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nhập mã Pin',
                style: Constants.textHeading,
              ),
              const Text(
                'Vui lòng nhập mã số gồm 6 chữ số được gửi tới',
              ),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return Text(
                    '${state.countryCode.dialCode} ${state.phone.value}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
              SizedBox(
                height: 16.h,
              ),
              SizedBox(
                width: 1.sw - (Constants.kPadding * 2),
                child: Pinput(
                  onChanged: (pin) {
                    context.read<OtpCubit>().pinChanged(pin);
                  },
                  length: 6,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Text('Mã sẽ hết hiệu lực trong '),
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 60, end: 0),
                    duration: const Duration(seconds: 60),
                    builder: (context, value, child) {
                      return Text(
                        '${value.toInt()}s',
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: Constants.kPadding.h / 2,
              ),
              BlocBuilder<OtpCubit, OtpState>(
                builder: (context, state) {
                  return state.status.isInProgress
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : MatchParentButton(
                          onPressed: state.isValid
                              ? () {
                                  verifyPin(context, state.otp.value);
                                }
                              : null,
                          label: 'Xác minh',
                        );
                },
              ),
              SizedBox(
                height: 16.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
