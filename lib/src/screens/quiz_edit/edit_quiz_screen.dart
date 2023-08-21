import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/shared_widget.dart';
import 'package:whizz/src/modules/collection/cubit/quiz_collection_cubit.dart';
import 'package:whizz/src/modules/quiz/bloc/quiz_bloc.dart';
import 'package:whizz/src/screens/quiz_create/widgets/popup_menu.dart';

class EditQuizScreen extends StatelessWidget {
  const EditQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Quiz'),
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
          padding: const EdgeInsets.all(AppConstant.kPadding),
          child: BlocBuilder<QuizBloc, QuizState>(
            builder: (context, quizState) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () => context
                        .read<QuizBloc>()
                        .add(OnQuizMediaChanged(context)),
                    child: ImageCover(media: quizState.quiz.media),
                  ),
                  const SizedBox(
                    height: AppConstant.kPadding,
                  ),
                  QuizFormField(
                    hintText: 'Name',
                    initialValue: quizState.quiz.title,
                    maxLength: 50,
                    onChanged: (title) =>
                        context.read<QuizBloc>().add(OnQuizTitleChanged(title)),
                  ),
                  const SizedBox(
                    height: AppConstant.kPadding,
                  ),
                  QuizFormField(
                    initialValue: quizState.quiz.description,
                    hintText: 'Description',
                    maxLines: 6,
                    maxLength: 500,
                    onChanged: (desc) => context
                        .read<QuizBloc>()
                        .add(OnQuizDescriptionChange(desc)),
                  ),
                  const SizedBox(
                    height: AppConstant.kPadding,
                  ),
                  BlocBuilder<QuizCollectionCubit, QuizCollectionState>(
                    builder: (context, state) {
                      return QuizCollectionDropDownField(
                        ctx: context,
                        initialValue: quizState.quiz.collectionId,
                        onChanged: (collectionId) {
                          context.read<QuizBloc>().add(
                              OnQuizCollectionChanged(collectionId as String));
                        },
                        label: const Text('Collection'),
                        items: state is QuizCollectionSuccess
                            ? state.collections
                            : [],
                      );
                    },
                  ),
                  const SizedBox(
                    height: AppConstant.kPadding,
                  ),
                  QuizVisibilityTextField(
                    initialValue: quizState.quiz.visibility.name,
                    onChanged: (val) => context
                        .read<QuizBloc>()
                        .add(OnQuizVisibilityChanged(val as String)),
                    label: const Text('Visibility'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(AppConstant.kPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context
                        .read<QuizBloc>()
                        .add(OnCreateNewQuestion(context, true)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.primaryColor,
                      elevation: 4,
                    ),
                    child: Text(
                      'Add Question',
                      style: AppConstant.textHeading.copyWith(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: AppConstant.kPadding,
                ),
                state.isLoading
                    ? Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const CircularProgressIndicator.adaptive(),
                          label: Text(
                            'Loading',
                            style: AppConstant.textHeading.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 4,
                          ),
                        ),
                      )
                    : Expanded(
                        child: ElevatedButton(
                          onPressed: state.isValid
                              ? () => context
                                  .read<QuizBloc>()
                                  .add(OnInitialNewQuiz(context))
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 4,
                          ),
                          child: Text(
                            'Save',
                            style: AppConstant.textHeading.copyWith(
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
