part of 'auth_screen.dart';

class LoginSection extends StatelessWidget {
  const LoginSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: CustomColors.paleGray,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(32),
                    ),
                  ),
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Email',
                ),
              ),
              Distance(
                height: 12.h,
              ),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: CustomColors.paleGray,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(32),
                    ),
                  ),
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Mật khẩu',
                ),
              ),
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
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(45),
                  backgroundColor: CustomColors.darkBrown,
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.images.loginFacebook.image(),
                  Distance(width: 4.w),
                  Assets.images.loginGoogle.image(),
                ],
              ),
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
    );
  }
}
