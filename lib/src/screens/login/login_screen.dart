import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/shared_widget.dart';
import 'package:whizz/src/gen/assets.gen.dart';
import 'package:whizz/src/modules/auth/bloc/auth_bloc.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    final phoneNumberController = useTextEditingController(text: '');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isError) {
            context.showErrorSnackBar(state.message ?? 'Unknown Error!');
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thử tài cùng Quizwhizz!',
                style: AppConstant.textTitle700,
              ),
              Text(
                'Đăng nhập / Đăng ký tài khoản ngay bây giờ',
                style: AppConstant.textSubtitle,
              ),
              SizedBox(
                height: AppConstant.kPadding.h * 2,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context
                        .read<AuthBloc>()
                        .add(CountryPickerChanged(context)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppConstant.kPadding.toDouble() / 2,
                        ),
                      ),
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return Row(
                            children: [
                              state.code.flagImage(),
                              const SizedBox(
                                width: AppConstant.kPadding / 4,
                              ),
                              Text(state.code.dialCode),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: AppConstant.kPadding / 2,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppConstant.kPadding.toDouble() / 2,
                        ),
                      ),
                      child: TextField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Số điện thoại của bạn',
                          hintStyle: AppConstant.textSubtitle.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Text.rich(
                TextSpan(
                  text: 'Tôi đồng ý với ',
                  children: [
                    TextSpan(
                      text: 'Điều kiện và Điều khoản',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.blue,
                      ),
                    ),
                    TextSpan(
                      text: ' liên quan đến việc sử dụng dịch vụ của ',
                    ),
                    TextSpan(
                      text: 'Quizwhizz',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppConstant.kPadding,
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const LoadingButton(
                      label: 'Đang xác thực',
                    );
                  }
                  return CustomButton(
                    onPressed: () => context.read<AuthBloc>().add(
                          SignInWithPhoneNumber(
                            context,
                            phoneNumberController.text,
                          ),
                        ),
                    label: 'Tiếp tục',
                  );
                },
              ),
              const Spacer(
                flex: 2,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Divider(),
                  Text('Hoặc đăng nhập bằng'),
                  Divider(),
                ],
              ),
              const SizedBox(
                height: AppConstant.kPadding / 2.0,
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: state.isLoading
                            ? null
                            : () => context
                                .read<AuthBloc>()
                                .add(const SignInWithGoogle()),
                        child: Assets.images.loginGoogle.image(
                          height: 36,
                          width: 36,
                        ),
                      ),
                      const SizedBox(
                        width: AppConstant.kPadding * 1.0,
                      ),
                      GestureDetector(
                        onTap: state.isLoading
                            ? null
                            : () => context
                                .read<AuthBloc>()
                                .add(const SignInWithTwitter()),
                        child: Assets.images.loginTwitter.image(
                          height: 36,
                          width: 36,
                        ),
                      )
                    ],
                  );
                },
              ),
              const SizedBox(
                height: AppConstant.kPadding * 2.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
