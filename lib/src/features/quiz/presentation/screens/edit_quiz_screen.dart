import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/quiz_textfield.dart';
import 'package:whizz/src/features/quiz/data/bloc/quiz_bloc.dart';

import 'package:whizz/src/features/quiz/presentation/popups/popup_menu.dart';
import 'package:whizz/src/features/quiz/presentation/widgets/image_cover.dart';

class EditQuizScreen extends StatelessWidget {
  const EditQuizScreen({super.key});

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
          child: BlocBuilder<QuizBloc, QuizState>(
            builder: (context, state) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () => context
                        .read<QuizBloc>()
                        .add(OnQuizMediaChanged(context)),
                    child: ImageCover(media: state.quiz.media),
                  ),
                  const SizedBox(
                    height: Constants.kPadding,
                  ),
                  QuizFormField(
                    hintText: 'Name',
                    initialValue: state.quiz.title,
                    maxLength: 50,
                    onChanged: (title) =>
                        context.read<QuizBloc>().add(OnQuizTitleChanged(title)),
                  ),
                  const SizedBox(
                    height: Constants.kPadding,
                  ),
                  QuizFormField(
                    hintText: 'Description',
                    maxLines: 6,
                    maxLength: 500,
                    onChanged: (desc) => context
                        .read<QuizBloc>()
                        .add(OnQuizDescriptionChange(desc)),
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
                    onChanged: (val) => context
                        .read<QuizBloc>()
                        .add(OnQuizVisibilityChanged(val as String)),
                    label: const Text('Visibility'),
                    items: ListEnum.visibility,
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
            padding: const EdgeInsets.all(Constants.kPadding),
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
                    ? Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const CircularProgressIndicator.adaptive(),
                          label: Text(
                            'Saving',
                            style: Constants.textHeading.copyWith(
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
