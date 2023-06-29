import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whizz/src/common/shared/shared_widget.dart';
import 'package:whizz/src/features/auth/ui/signup/components/signup_section.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 1.sh,
            ),
            const ImageHeader(),
            const SignUpSection(),
          ],
        ),
      ),
    );
  }
}
