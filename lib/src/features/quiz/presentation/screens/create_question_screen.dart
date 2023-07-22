import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/features/quiz/data/bloc/quiz_bloc.dart';
import 'package:whizz/src/features/quiz/presentation/dialogs/options_builder.dart';
import 'package:whizz/src/features/quiz/presentation/widgets/image_cover.dart';
import 'package:whizz/src/features/quiz/presentation/widgets/preview_question_card.dart';
import 'package:whizz/src/features/quiz/presentation/widgets/quiz_answers.dart';

class CreateQuestionScreen extends StatelessWidget with OptionsSelector {
  const CreateQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Create Question'),
        actions: [
          IconButton(
            onPressed: () {
              context.showConfirmDialog(
                title: 'Are you sure?',
                description:
                    'Do you want to delete this question? This process cannot be undone.',
                onNegativeButton: () {},
                onPositiveButton: () => context
                    .read<QuizBloc>()
                    .add(const OnRemoveCurrentQuestion()),
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Constants.kPadding),
        child: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context
                            .read<QuizBloc>()
                            .add(OnQuestionMediaChanged(context));
                      },
                      child: ImageCover(
                        media: state.quiz.questions[state.index].media,
                      ),
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
                      onChanged: (name) => context
                          .read<QuizBloc>()
                          .add(OnQuestionNameChanged(name)),
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
                        context
                            .read<QuizBloc>()
                            .add(OnCreateNewQuestion(context));
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
