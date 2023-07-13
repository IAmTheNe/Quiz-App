import 'package:flutter/material.dart';
import 'package:whizz/src/common/constants/constants.dart';

class PreviewQuestionCard extends StatelessWidget {
  const PreviewQuestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  spacing: Constants.kPadding,
                  direction: Axis.horizontal,
                  children: List.generate(
                    10,
                    (index) => CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: Constants.kPadding,
        ),
        IconButton.filled(
          onPressed: () {},
          style: IconButton.styleFrom(),
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
