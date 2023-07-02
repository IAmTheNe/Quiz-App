import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/shared_widget.dart';
import 'package:whizz/src/features/auth/data/bloc/login/login_cubit.dart';
import 'package:whizz/src/features/auth/data/bloc/register/signup_cubit.dart';
import 'package:whizz/src/gen/assets.gen.dart';
import 'package:whizz/src/gen/colors.gen.dart';
import 'package:whizz/src/router/app_router.dart';

class SignUpSection extends StatelessWidget {
  const SignUpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          context.showErrorSnackBar(
              state.errorMessage ?? 'Authentication Failed!');
        }
      },
      child: Positioned(
        top: .35.sh - 35.h,
        left: 0,
        right: 0,
        child: Container(
          height: .65.sh + 35.h,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                children: [
                  Distance(
                    height: 24.h,
                  ),
                  Text(
                    'Đăng ký',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Constants.primaryColor,
                    ),
                  ),
                  Distance(
                    height: 16.h,
                  ),
                  const EmailField(),
                  Distance(
                    height: 12.h,
                  ),
                  const PasswordField(),
                  Distance(
                    height: 12.h,
                  ),
                  const ConfirmedPasswordField(),
                  Distance(
                    height: 20.h,
                  ),
                  const SignUpButton(),
                  Distance(
                    height: 20.h,
                  ),
                  Text(
                    'Hoặc đăng nhập với',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Distance(
                    height: 8.h,
                  ),
                  const AnotherMethodLoginSection(),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      context.goNamed(RouterPath.login.name);
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: 'Bạn đã có tài khoản? ',
                        children: [
                          TextSpan(
                            text: 'Đăng nhập ngay',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0000FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Distance(
                    height: 32.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnotherMethodLoginSection extends StatelessWidget {
  const AnotherMethodLoginSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            context.read<LoginCubit>().loginWithGoogle();
          },
          child: Assets.images.loginGoogle.image(),
        ),
        Distance(width: 4.w),
        Assets.images.loginFacebook.image(),
      ],
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({
    super.key,
  });

  void register(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<SignUpCubit>().signUpSubmitted();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return (state.status.isInProgress)
            ? const CircularProgressIndicator.adaptive()
            : CustomButton(
                onPressed: state.isValid ? () => register(context) : null,
                title: 'Đăng ký ngay',
              );
      },
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          return TextField(
            obscureText: true,
            onChanged: (value) {
              context.read<SignUpCubit>().passwordChanged(value);
            },
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Palettes.paleGray,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(32),
                ),
              ),
              prefixIcon: const Icon(Icons.lock),
              hintText: 'Mật khẩu',
              errorText: state.password.displayError != null
                  ? 'Invalid Password'
                  : null,
            ),
          );
        });
  }
}

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_emailInput_textField'),
          onChanged: (value) {
            context.read<SignUpCubit>().emailChanged(value);
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Palettes.paleGray,
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                Radius.circular(32),
              ),
            ),
            prefixIcon: const Icon(Icons.email),
            hintText: 'Email',
            errorText:
                state.email.displayError != null ? 'Invalid Email' : null,
          ),
        );
      },
    );
  }
}

class ConfirmedPasswordField extends StatelessWidget {
  const ConfirmedPasswordField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          obscureText: true,
          onChanged: (value) {
            context.read<SignUpCubit>().confirmedPasswordChanged(value);
          },
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Palettes.paleGray,
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                Radius.circular(32),
              ),
            ),
            prefixIcon: const Icon(Icons.lock),
            hintText: 'Nhập lại mật khẩu',
            errorText: state.confirmedPassword.displayError != null
                ? 'Invalid Password'
                : null,
          ),
        );
      },
    );
  }
}
