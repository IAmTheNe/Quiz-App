import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';

mixin OptionsSelector {
  void showInputTitle({
    required BuildContext context,
    void Function()? onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter question'),
          content: TextFormField(
            maxLength: 150,
            maxLines: 3,
            minLines: 1,
            style: Constants.textSubtitle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: onPressed,
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showAnswer({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Answer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                maxLength: 150,
                maxLines: 3,
                minLines: 1,
                style: Constants.textSubtitle,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Correct answer'),
                  const SizedBox(width: Constants.kPadding / 2),
                  Switch(value: false, onChanged: (val) {}),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
