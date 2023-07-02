import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/shared_widget.dart';
import 'package:whizz/src/features/auth/data/bloc/login/login_cubit.dart';
import 'package:whizz/src/gen/assets.gen.dart';
import 'package:whizz/src/router/app_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void showCountryPicker(BuildContext context) {
    context.showCountryPicker().then((value) {
      if (value != null) {
        context.read<LoginCubit>().countryChanged(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thử tài cùng Quizwhizz!',
              style: Constants.textTitle700,
            ),
            Text(
              'Đăng nhập / Đăng ký tài khoản ngay bây giờ',
              style: Constants.textSubtitle,
            ),
            SizedBox(
              height: Constants.kPadding.h * 2,
            ),
            Row(
              children: [
                BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        showCountryPicker(context);
                      },
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
                            Constants.kPadding.toDouble() / 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            state.code.flagImage(),
                            const SizedBox(
                              width: Constants.kPadding / 4,
                            ),
                            Text(state.code.dialCode),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: Constants.kPadding / 2,
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
                        Constants.kPadding.toDouble() / 2,
                      ),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: context.read<LoginCubit>().phoneChanged,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Số điện thoại của bạn',
                        hintStyle: Constants.textSubtitle.copyWith(
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
              height: Constants.kPadding * 1.0,
            ),
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return state.status.isInProgress
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : MatchParentButton(
                        onPressed: state.isValid
                            ? () {
                                context.pushNamed(RouterPath.otp.name);
                              }
                            : null,
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
              height: Constants.kPadding / 2.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: context.read<LoginCubit>().loginWithGoogle,
                  child: Assets.images.loginGoogle.image(
                    height: 36,
                    width: 36,
                  ),
                ),
                const SizedBox(
                  width: Constants.kPadding * 1.0,
                ),
                Assets.images.loginTwitter.image(
                  height: 36,
                  width: 36,
                )
              ],
            ),
            const SizedBox(
              height: Constants.kPadding * 2.0,
            ),
          ],
        ),
      ),
    );
  }
}
