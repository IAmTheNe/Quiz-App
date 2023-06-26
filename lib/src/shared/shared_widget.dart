import 'package:flutter/material.dart';
import 'package:whizz/src/gen/colors.gen.dart';

class Distance extends StatelessWidget {
  const Distance({
    super.key,
    this.height = 0.0,
    this.width = 0.0,
    this.child,
  });

  final double height;
  final double width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: child,
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final void Function()? onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(45),
        backgroundColor: CustomColors.darkBrown,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
