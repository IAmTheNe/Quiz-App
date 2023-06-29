import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:whizz/src/features/auth/ui/login/components/image_header.dart';
import 'package:whizz/src/features/auth/ui/login/components/login_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 1.sh,
            ),
            const ImageHeader(),
            const LoginSection(),
          ],
        ),
      ),
    );
  }
}
