import 'package:flutter/material.dart';

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
