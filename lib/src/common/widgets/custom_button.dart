import 'package:flutter/material.dart';
import 'package:whizz/src/common/constants/constants.dart';

class MatchParentButton extends StatelessWidget {
  const MatchParentButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final void Function()? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Constants.primaryColor,
        minimumSize: const Size.fromHeight(40),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
