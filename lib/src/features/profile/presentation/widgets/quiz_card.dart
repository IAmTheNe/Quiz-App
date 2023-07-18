import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/features/quiz/data/models/quiz.dart';
import 'package:whizz/src/router/app_router.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({super.key, required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          RouterPath.quizDetail.name,
          pathParameters: {'id': quiz.id},
          extra: quiz,
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      image: quiz.media.imageUrl != null
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(
                                  quiz.media.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(Constants.kPadding),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(Constants.kPadding / 4),
                    decoration: const BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(Constants.kPadding),
                        bottomLeft: Radius.circular(Constants.kPadding),
                      ),
                    ),
                    child: Text(
                      '${quiz.questions.length} questions',
                      style: Constants.textSubtitle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: Constants.kPadding / 2,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.title,
                  style: Constants.textTitle700,
                ),
                Text(
                  '${quiz.createdAt!.millisecondsSinceEpoch}',
                  style: Constants.textSubtitle.copyWith(
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
