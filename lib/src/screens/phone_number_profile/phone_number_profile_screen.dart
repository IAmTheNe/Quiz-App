import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/utils/pick_image.dart';
import 'package:whizz/src/common/widgets/custom_button.dart';
import 'package:whizz/src/gen/assets.gen.dart';
import 'package:whizz/src/modules/auth/bloc/auth_bloc.dart';
import 'package:whizz/src/router/app_router.dart';

class PhoneNumberProfileScreen extends StatefulWidget {
  const PhoneNumberProfileScreen({super.key});

  @override
  State<PhoneNumberProfileScreen> createState() =>
      _PhoneNumberProfileScreenState();
}

class _PhoneNumberProfileScreenState extends State<PhoneNumberProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  void selectAvatar() async {
    image = await PickImage.pickImage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstant.kPadding),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(.06.sh),
              ),
              child: image == null
                  ? CircleAvatar(
                      radius: .06.sh,
                      backgroundColor: Colors.white,
                      backgroundImage: Assets.images.unknownUser.provider(),
                    )
                  : CircleAvatar(
                      radius: .06.sh,
                      backgroundColor: Colors.white,
                      backgroundImage: FileImage(image!),
                    ),
            ),
            const SizedBox(
              height: AppConstant.kPadding / 2,
            ),
            ElevatedButton.icon(
              onPressed: selectAvatar,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: const Text('Choose an image'),
            ),
            const SizedBox(
              height: AppConstant.kPadding,
            ),
            Container(
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
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Display name',
                  hintStyle: AppConstant.textSubtitle.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const Spacer(),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const LoadingButton(label: 'Loading');
                }
                return CustomButton(
                  onPressed: () {
                    if (nameController.text.isEmpty) {
                      context
                          .showErrorSnackBar('Please enter your display name!');
                    } else {
                      context
                          .read<AuthBloc>()
                          .add(UpdateUser(nameController.text, image));
                      context.goNamed(RouterPath.home.name);
                    }
                  },
                  label: 'Confirm',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
