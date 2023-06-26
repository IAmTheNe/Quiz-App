part of 'auth_screen.dart';

class LoginSection extends StatelessWidget {
  const LoginSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failed!'),
              ),
            );
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              children: [
                Distance(
                  height: 24.h,
                ),
                Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: CustomColors.darkBrown,
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
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent),
                    ),
                    child: Text(
                      'Quên mật khẩu',
                      style: TextStyle(
                        color: const Color(0xFF0000FF).withOpacity(.6),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Distance(
                  height: 20.h,
                ),
                const LoginButton(),
                Distance(
                  height: 20.h,
                ),
                Text(
                  'Hoặc đăng nhập với',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: CustomColors.darkBrown,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Distance(
                  height: 8.h,
                ),
                const AnotherMethodLoginSection(),
                const Spacer(),
                const Text.rich(
                  TextSpan(
                    text: 'Bạn không có tài khoản? ',
                    children: [
                      TextSpan(
                        text: 'Đăng ký ngay',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0000FF),
                        ),
                      ),
                    ],
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
            context.read<AuthCubit>().loginWithGoogle();
          },
          child: Assets.images.loginGoogle.image(),
        ),
        Distance(width: 4.w),
        Assets.images.loginFacebook.image(),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
  });

  void login(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().loginWithCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return (state.status.isInProgress)
            ? const CircularProgressIndicator.adaptive()
            : CustomButton(
                onPressed: state.isValid ? () => login(context) : null,
                title: 'Đăng nhập',
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
    return BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          return TextField(
            obscureText: true,
            onChanged: (value) {
              context.read<AuthCubit>().passwordChanged(value);
            },
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: CustomColors.paleGray,
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
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          onChanged: (value) {
            context.read<AuthCubit>().emailChanged(value);
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: CustomColors.paleGray,
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
