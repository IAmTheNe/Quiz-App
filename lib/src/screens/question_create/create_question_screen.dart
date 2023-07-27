import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/shared_widget.dart';

import 'package:whizz/src/modules/quiz/bloc/create_edit_quiz/quiz_bloc.dart';

import 'package:whizz/src/screens/question_create/widgets/preview_question_card.dart';
import 'package:whizz/src/screens/question_create/widgets/question_answer.dart';

class CreateQuestionScreen extends StatelessWidget {
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
        padding: const EdgeInsets.all(AppConstant.kPadding),
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
                      bottom: AppConstant.kPadding / 2,
                      left: AppConstant.kPadding,
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
                          style: AppConstant.textSubtitle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppConstant.kPadding / 2,
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
                    padding: const EdgeInsets.all(AppConstant.kPadding / 2),
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxHeight: .08.sh,
                      minHeight: .05.sh,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6d5ff6),
                      borderRadius: BorderRadius.circular(AppConstant.kPadding),
                    ),
                    child: Text(
                      state.quiz.questions[state.index].name.isEmpty
                          ? 'Add title'
                          : state.quiz.questions[state.index].name,
                      style: AppConstant.textSubtitle.copyWith(
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
                  height: AppConstant.kPadding / 2,
                ),
                Expanded(
                  child: QuestionAnswer(
                    answers: state.quiz.questions[state.index].answers,
                  ),
                ),
                const SizedBox(
                  height: AppConstant.kPadding / 2,
                ),
                Row(
                  children: [
                    PreviewQuestionCard(
                      questions: state.quiz.questions,
                    ),
                    const SizedBox(
                      width: AppConstant.kPadding,
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
          style: AppConstant.textSubtitle,
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
