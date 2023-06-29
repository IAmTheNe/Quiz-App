// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whizz/src/common/shared/shared_widget.dart';
import 'package:whizz/src/features/auth/data/bloc/verify_email/verify_email_cubit.dart';
import 'package:whizz/src/features/home/ui/home_screen.dart';
import 'package:whizz/src/gen/assets.gen.dart';
import 'package:whizz/src/gen/colors.gen.dart';

class VerificationEmailScreen extends StatefulWidget {
  const VerificationEmailScreen({super.key});

  @override
  State<VerificationEmailScreen> createState() =>
      _VerificationEmailScreenState();
}

class _VerificationEmailScreenState extends State<VerificationEmailScreen> {
  Timer? _timer;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await checkEmailVerified();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) async {
        await checkEmailVerified();
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
      builder: (context, state) {
        return state.isVerified
            ? const HomeScreen()
            : const VerificationSection();
      },
    );
  }

  Future<void> checkEmailVerified() async {
    final isVerified = await context.read<VerifyEmailCubit>().isEmailVerified;
    if (!isVerified) {
      context.read<VerifyEmailCubit>().sendEmailVerified();
    } else {
      _timer?.cancel();
    }
  }
}

class VerificationSection extends StatelessWidget {
  const VerificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Assets.raw.sendEmail.lottie(
                    repeat: true,
                    height: .25.sh,
                  ),
                  const Spacer(),
                  Text(
                    'Xác thực địa chỉ Email',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Palettes.darkBrown,
                    ),
                  ),
                  Distance(
                    height: 12.h,
                  ),
                  Text(
                    'Chúng tôi vừa gửi một liên kết xác minh đến địa chỉ email của bạn. Vui lòng kiểm tra hòm thư và nhấp vào liên kết để xác minh địa chỉ email.',
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Distance(
                    height: 16.h,
                  ),
                  Text(
                    'Trong trường hợp không tự động chuyển hướng sau khi xác minh, vui lòng nhấp vào nút "Tiếp tục" để tiếp tục quá trình.',
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  CustomButton(
                      onPressed: () {
                        context.read<VerifyEmailCubit>().checkEmailVerified();
                      },
                      title: 'Tiếp tục'),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Gửi lại liên kết Email'),
                  ),
                  Distance(
                    height: 16.h,
                  ),
                  TextButton.icon(
                      onPressed: () {
                        context.read<VerifyEmailCubit>().cancel();
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Quay về màn hình đăng nhập')),
                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
