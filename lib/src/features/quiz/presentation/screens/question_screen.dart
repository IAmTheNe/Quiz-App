import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/features/quiz/data/bloc/quiz_cubit.dart';
import 'package:whizz/src/features/quiz/data/models/media.dart';
import 'package:whizz/src/features/quiz/data/models/quiz.dart';
import 'package:whizz/src/features/quiz/presentation/dialogs/options_builder.dart';
import 'package:whizz/src/features/quiz/presentation/widgets/image_cover.dart';
import 'package:whizz/src/features/quiz/presentation/widgets/preview_question_card.dart';
import 'package:whizz/src/features/quiz/presentation/widgets/quiz_answers.dart';
import 'package:whizz/src/features/quiz/presentation/widgets/rainbow_container.dart';
import 'package:whizz/src/router/app_router.dart';

class CreateQuestionScreen extends StatelessWidget with OptionsSelector {
  const CreateQuestionScreen({super.key});

  void intent(BuildContext context) async {
    final result =
        await context.pushNamed<(String, AttachType)>(RouterPath.media.name);

    if (result?.$1 != null) {
      // ignore: use_build_context_synchronously
      context.read<QuizCubit>().attachmentChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Create Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Constants.kPadding),
        child: BlocBuilder<QuizCubit, QuizState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        intent(context);
                      },
                      child: state.quiz.media.imageUrl != null
                          ? ImageCover(
                              media: Media(
                                imageUrl: state.quiz.media.imageUrl,
                                type: state.quiz.media.type,
                              ),
                            )
                          : const RainbowContainer(),
                    ),
                    Positioned(
                      bottom: Constants.kPadding / 2,
                      left: Constants.kPadding,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF036be5),
                        ),
                        icon: const Icon(
                          Icons.timer,
                          color: Colors.white,
                        ),
                        label: Text(
                          '10 sec',
                          style: Constants.textSubtitle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: Constants.kPadding / 2,
                ),
                GestureDetector(
                  onTap: () {
                    showInputTitle(
                      context: context,
                      initialValue: state.quiz.questions[state.index].name,
                      onChanged: (val) {
                        context
                            .read<QuizCubit>()
                            .questionNameChanged(name: val);
                      },
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(Constants.kPadding / 2),
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxHeight: .08.sh,
                      minHeight: .05.sh,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6d5ff6),
                      borderRadius: BorderRadius.circular(Constants.kPadding),
                    ),
                    child: Text(
                      state.quiz.questions[state.index].name.isEmpty
                          ? 'Add title'
                          : state.quiz.questions[state.index].name,
                      style: Constants.textSubtitle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: null,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
                const SizedBox(
                  height: Constants.kPadding / 2,
                ),
                Expanded(
                  child: QuizAnswers(
                    answers: state.quiz.questions[state.index].answers,
                  ),
                ),
                const SizedBox(
                  height: Constants.kPadding / 2,
                ),
                Row(
                  children: [
                    PreviewQuestionCard(
                      questions: state.quiz.questions,
                    ),
                    const SizedBox(
                      width: Constants.kPadding,
                    ),
                    IconButton.filled(
                      onPressed: () {
                        context.read<QuizCubit>().createNewQuestion();
                      },
                      style: IconButton.styleFrom(),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
