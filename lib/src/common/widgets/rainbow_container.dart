import 'package:flutter/material.dart';
import 'package:whizz/src/common/constants/constants.dart';

class RainbowContainer extends StatelessWidget {
  const RainbowContainer({
    super.key,
    this.isPreview = false,
  });

  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // color: Colors.black26,
          borderRadius: const BorderRadius.all(
            Radius.circular(AppConstant.kPadding),
          ),
          gradient: AppConstant.sunsetGradient,
        ),
        child: !isPreview
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined),
                  SizedBox(height: AppConstant.kPadding / 4),
                  Text('Tap to add cover image'),
                ],
              )
            : null,
      ),
    );
  }
}