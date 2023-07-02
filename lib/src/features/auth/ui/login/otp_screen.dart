
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/widgets/custom_button.dart';
import 'package:whizz/src/features/auth/data/bloc/login/login_cubit.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.codeSent});

  final (String, int) codeSent;

  void verifyPin(BuildContext context, String pin) {
    context.read<LoginCubit>().verifyOtp(
          otp: pin,
          verificationId: codeSent.$1,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
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
                  '${state.code.dialCode} ${state.phone.value}',
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
                length: 6,
                onCompleted: (pin) {
                  verifyPin(context, pin);
                },
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const Text('Mã sẽ hết hiệu lực trong '),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: codeSent.$2.toDouble(), end: 0),
                  duration: Duration(seconds: codeSent.$2),
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
            MatchParentButton(
              onPressed: () {},
              label: 'Xác minh',
            ),
            SizedBox(
              height: 16.h,
            ),
          ],
        ),
      ),
    );
  }
}
