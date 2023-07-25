import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/features/quiz/data/models/quiz.dart';
import 'package:whizz/src/features/quiz/presentation/widgets/image_cover.dart';

class QuestionDetailScreen extends StatelessWidget {
  const QuestionDetailScreen({
    super.key,
    required this.quiz,
  });

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Constants.kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 3 / 2,
                child: ImageCover(
                  media: quiz.media,
                  isPreview: true,
                ),
              ),
              const SizedBox(
                height: Constants.kPadding / 2,
              ),
              Text(
                quiz.title,
                style: Constants.textHeading.copyWith(
                  fontSize: 22.sp,
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                height: Constants.kPadding / 2,
              ),
              Text(
                'Description',
                style: Constants.textTitle700.copyWith(
                  color: Constants.primaryColor,
                ),
              ),
              const SizedBox(
                height: Constants.kPadding / 2,
              ),
              Text(
                quiz.description!.isEmpty ? 'Empty' : quiz.description!,
                style: Constants.textSubtitle,
              ),
              const SizedBox(
                height: Constants.kPadding / 2,
              ),
              Text(
                '${quiz.questions.length} question',
                style: Constants.textTitle700.copyWith(
                  color: Constants.primaryColor,
                ),
              ),
              const SizedBox(
                height: Constants.kPadding / 2,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: ImageCover(
                                media: quiz.questions[index].media,
                                isPreview: true,
                              ),
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
                                  quiz.questions[index].name,
                                  style: Constants.textTitle700.copyWith(
                                    color: Constants.primaryColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: Constants.kPadding / 2,
                      ),
                    ],
                  );
                },
                itemCount: quiz.questions.length,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(Constants.kPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primaryColor,
                  elevation: 4,
                ),
                child: FittedBox(
                  child: Text(
                    'Play with friend',
                    style: Constants.textHeading.copyWith(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: Constants.kPadding,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 4,
                ),
                child: FittedBox(
                  child: Text(
                    'Play solo',
                    style: Constants.textHeading.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
