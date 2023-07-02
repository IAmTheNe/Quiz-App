import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/shared_widget.dart';
import 'package:whizz/src/features/auth/data/bloc/reset_password/reset_password_cubit.dart';
import 'package:whizz/src/gen/colors.gen.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            context.showErrorSnackBar(
              state.errorMessage ?? 'Không thể gửi email xác nhận!',
            );
          }

          if (state.status.isSuccess && state.isValid) {
            context.showSuccessSnackBar('Đã gửi email xác nhận');
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Thay đổi mật khẩu',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Distance(
                height: 8.h,
              ),
              const Text(
                'Vui lòng nhập địa chỉ email của bạn, chúng tôi sẽ gửi cho bạn một liên kết để đặt lại mật khẩu.',
                textAlign: TextAlign.center,
              ),
              Distance(
                height: 16.h,
              ),
              const EmailField(),
              const Spacer(),
              BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                builder: (context, state) {
                  return (state.status.isInProgress)
                      ? const CircularProgressIndicator.adaptive()
                      : CustomButton(
                          onPressed: state.isValid
                              ? () {
                                  FocusScope.of(context).unfocus();
                                  context
                                      .read<ResetPasswordCubit>()
                                      .sendPasswordResetEmail()
                                      .then((_) => context.pop());
                                }
                              : null,
                          title: 'Xác nhận',
                        );
                },
              ),
              Distance(
                height: 32.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('resetPassForm_emailInput_textField'),
          onChanged: (value) {
            context.read<ResetPasswordCubit>().emailChanged(value);
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
