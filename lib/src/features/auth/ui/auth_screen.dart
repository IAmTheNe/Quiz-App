import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whizz/src/gen/assets.gen.dart';
import 'package:whizz/src/gen/colors.gen.dart';
import 'package:whizz/src/shared/distance.dart';

part 'image_header.dart';
part 'login_section.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

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



