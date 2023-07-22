import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/features/quiz/data/models/answer.dart';

mixin OptionsSelector {
  void showInputTitle({
    required BuildContext context,
    required String initialValue,
    void Function(String)? onChanged,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter question'),
          content: TextFormField(
            autofocus: true,
            maxLength: 150,
            maxLines: 3,
            minLines: 1,
            initialValue: initialValue,
            onChanged: onChanged,
            style: Constants.textSubtitle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showAnswer({
    required BuildContext context,
    required Answer answer,
    void Function(String)? onChanged,
    void Function(bool)? onToggled,
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
                autofocus: true,
                maxLength: 150,
                maxLines: 3,
                minLines: 1,
                initialValue: answer.answer,
                style: Constants.textSubtitle,
                onChanged: onChanged,
              ),
              SwitchListTile(
                value: answer.isCorrect,
                dense: true,
                onChanged: (val) {
                  onToggled!(val);
                  context.pop();
                },
                title: const Text('Correct answer'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: context.pop,
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
