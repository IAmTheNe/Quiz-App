import 'package:flutter/material.dart';
import 'package:whizz/src/common/constants/constants.dart';

class QuestionOptionsTabBar extends StatelessWidget {
  const QuestionOptionsTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('10 sec'),
          ),
        ),
        const SizedBox(
          width: Constants.kPadding / 2,
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('1 Point'),
          ),
        ),
        const SizedBox(
          width: Constants.kPadding / 2,
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Quiz'),
          ),
        ),
      ],
    );
  }
}
