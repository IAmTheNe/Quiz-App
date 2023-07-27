import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/features/quiz/data/bloc/quiz_bloc.dart';
import 'package:whizz/src/features/quiz/data/models/quiz.dart';
import 'package:whizz/src/common/widgets/image_cover.dart';
import 'package:whizz/src/router/app_router.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({super.key, required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          RouterPath.quizEdit.name,
          extra: context.read<QuizBloc>()..add(OnGoToEditScreen(quiz)),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                /// The `ImageCover` widget is used to display an image cover for the quiz. It takes two
                /// parameters: `media` and `isPreview`.
                // ImageCover(
                //   media: quiz.media,
                //   isPreview: true,
                // ),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstant.kPadding / 4,
                      horizontal: AppConstant.kPadding,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(AppConstant.kPadding),
                        bottomLeft: Radius.circular(AppConstant.kPadding),
                      ),
                    ),
                    child: Text(
                      '${quiz.questions.length} questions',
                      style: AppConstant.textSubtitle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: AppConstant.kPadding / 2,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.title,
                  style: AppConstant.textTitle700,
                ),
                Text(
                  quiz.createdAt!.millisecondsSinceEpoch.countDay(),
                  style: AppConstant.textSubtitle.copyWith(
                    color: Colors.grey.shade700,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
