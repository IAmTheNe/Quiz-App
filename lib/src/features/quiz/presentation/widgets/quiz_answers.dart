import 'package:flutter/material.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/features/quiz/presentation/dialogs/options_builder.dart';

class QuizAnswers extends StatelessWidget with OptionsSelector {
  const QuizAnswers({super.key});

  final listColors = const [
    Color(0xFFe35454),
    Color(0xFF30b0c7),
    Color(0xFFff9500),
    Color(0xFF3ed684),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        childAspectRatio: 16 / 9,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            showAnswer(context: context);
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(Constants.kPadding / 2),
            decoration: BoxDecoration(
              color: listColors[index],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Add answer',
              style: Constants.textSubtitle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              maxLines: null,
              textAlign: TextAlign.justify,
              overflow: TextOverflow.visible,
            ),
          ),
        );
      },
    );
  }
}
