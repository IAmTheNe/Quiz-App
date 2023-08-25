import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/widgets/image_cover.dart';
import 'package:whizz/src/modules/lobby/cubit/lobby_cubit.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/router/app_router.dart';
import 'package:whizz/src/screens/quiz_detail/widgets/popup_menu.dart';

class QuestionDetailScreen extends StatelessWidget {
  const QuestionDetailScreen({
    super.key,
    required this.quiz,
  });

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        actions: [
          CreateOptionsPopupMenu(quiz: quiz),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstant.kPadding),
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
                height: AppConstant.kPadding / 2,
              ),
              Text(
                quiz.title,
                style: AppConstant.textHeading.copyWith(
                  fontSize: 22.sp,
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                height: AppConstant.kPadding * 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstant.kPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(l10n.quiz_played),
                          const SizedBox(
                            height: AppConstant.kPadding / 4,
                          ),
                          Text(
                            quiz.playedCount.toString(),
                            style: AppConstant.textTitle700,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(l10n.quiz_rating),
                          const SizedBox(
                            height: AppConstant.kPadding / 4,
                          ),
                          Text(
                            '${quiz.rating.toStringAsFixed(1)} ⭐',
                            style: AppConstant.textTitle700,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(l10n.quiz_question_count),
                          const SizedBox(
                            height: AppConstant.kPadding / 4,
                          ),
                          Text(
                            quiz.questions.length.toString(),
                            style: AppConstant.textTitle700,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppConstant.kPadding * 2,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        CachedNetworkImageProvider(quiz.author.avatar!),
                  ),
                  const SizedBox(
                    width: AppConstant.kPadding / 2,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quiz.author.name!,
                        style: AppConstant.textTitle700.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        '@${quiz.author.id}',
                        style: AppConstant.textSubtitle.copyWith(
                          fontSize: 10.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: AppConstant.kPadding,
              ),
              Text(
                l10n.quiz_description,
                style: AppConstant.textTitle700.copyWith(
                  color: AppConstant.primaryColor,
                ),
              ),
              const SizedBox(
                height: AppConstant.kPadding / 2,
              ),
              Text(
                quiz.description!.isEmpty
                    ? l10n.quiz_description_empty
                    : quiz.description!,
                style: AppConstant.textSubtitle,
              ),
              // const SizedBox(
              //   height: AppConstant.kPadding / 2,
              // ),
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     return Column(
              //       children: [
              //         Row(
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             Expanded(
              //               child: AspectRatio(
              //                 aspectRatio: 4 / 3,
              //                 child: ImageCover(
              //                   media: quiz.questions[index].media,
              //                   isPreview: true,
              //                 ),
              //               ),
              //             ),
              //             const SizedBox(
              //               width: AppConstant.kPadding / 2,
              //             ),
              //             Expanded(
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     quiz.questions[index].name,
              //                     style: AppConstant.textTitle700.copyWith(
              //                       color: AppConstant.primaryColor,
              //                       fontSize: 14.sp,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //         const SizedBox(
              //           height: AppConstant.kPadding / 2,
              //         ),
              //       ],
              //     );
              //   },
              //   itemCount: quiz.questions.length,
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppConstant.kPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context
                      .read<LobbyCubit>()
                      .createLobby(quiz, isSoloMode: false);
                  context.goNamed(
                    RouterPath.lobby.name,
                    extra: false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.primaryColor,
                  elevation: 4,
                ),
                child: FittedBox(
                  child: Text(
                    l10n.quiz_play_friend,
                    style: AppConstant.textHeading.copyWith(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: AppConstant.kPadding,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.read<LobbyCubit>().createLobby(quiz);
                  context.goNamed(
                    RouterPath.lobby.name,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 4,
                ),
                child: FittedBox(
                  child: Text(
                    l10n.quiz_play_solo,
                    style: AppConstant.textHeading.copyWith(
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
