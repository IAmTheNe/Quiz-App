import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/quiz_textfield.dart';
import 'package:whizz/src/features/quiz/data/bloc/quiz_cubit.dart';
import 'package:whizz/src/features/quiz/data/controllers/quiz_controller.dart';
import 'package:whizz/src/features/quiz/presentation/popups/popup_menu.dart';
import 'package:whizz/src/features/quiz/presentation/widgets/image_cover.dart';
import 'package:whizz/src/router/app_router.dart';

class CreateQuizScreen extends StatelessWidget {
  const CreateQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quiz'),
        leading: IconButton(
          onPressed: () {
            context.showConfirmDialog(
              title: 'Discard changes?',
              description: 'Changes you made won\'t be saved!',
              onPositiveButton: context.pop,
              onNegativeButton: () {},
            );
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: const [
          CreateOptionsPopupMenu(),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Constants.kPadding),
          child: BlocBuilder<QuizCubit, QuizState>(
            builder: (context, state) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      QuizController.intent(
                        context: context,
                        onResult: context.read<QuizCubit>().attachmentChanged,
                      );
                    },
                    child: ImageCover(media: state.quiz.media),
                  ),
                  const SizedBox(
                    height: Constants.kPadding,
                  ),
                  QuizFormField(
                    hintText: 'Name',
                    initialValue: state.quiz.title,
                    maxLength: 50,
                    onChanged: context.read<QuizCubit>().nameChanged,
                  ),
                  const SizedBox(
                    height: Constants.kPadding,
                  ),
                  QuizFormField(
                    hintText: 'Description',
                    maxLines: 6,
                    maxLength: 500,
                    onChanged: context.read<QuizCubit>().descriptionChanged,
                  ),
                  const SizedBox(
                    height: Constants.kPadding,
                  ),
                  QuizDropDownField(
                    onChanged: (val) {},
                    label: const Text('Collection'),
                    items: ListEnum.collections,
                  ),
                  const SizedBox(
                    height: Constants.kPadding,
                  ),
                  QuizDropDownField(
                    onChanged: (val) {
                      context
                          .read<QuizCubit>()
                          .visibilityChanged(val as String);
                    },
                    label: const Text('Visibility'),
                    items: ListEnum.visibility,
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(Constants.kPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (state.quiz.questions.isEmpty) {
                        context.read<QuizCubit>().createNewQuestion();
                      }
                      context.pushNamed(
                        RouterPath.question.name,
                        extra: context.read<QuizCubit>(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      elevation: 4,
                    ),
                    child: Text(
                      'Add Question',
                      style: Constants.textHeading.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: Constants.kPadding,
                ),
                state.isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : Expanded(
                        child: ElevatedButton(
                          onPressed: state.isValid
                              ? () =>
                                  QuizController.createQuiz(context: context)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 4,
                          ),
                          child: Text(
                            'Save',
                            style: Constants.textHeading.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
