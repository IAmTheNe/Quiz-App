import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/shared_widget.dart';
import 'package:whizz/src/modules/collection/bloc/quiz_collection_bloc.dart';
import 'package:whizz/src/modules/quiz/bloc/create_edit_quiz/quiz_bloc.dart';
import 'package:whizz/src/screens/quiz_create/widgets/popup_menu.dart';

// import 'package:whizz/src/features/discovery/data/bloc/quiz_collection_bloc.dart';
// import 'package:whizz/src/features/quiz/data/bloc/quiz_bloc.dart';

// import 'package:whizz/src/features/quiz/presentation/popups/popup_menu.dart';
// import 'package:whizz/src/common/widgets/image_cover.dart';

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
          padding: const EdgeInsets.all(AppConstant.kPadding),
          child: Column(
            children: [
              BlocBuilder<QuizBloc, QuizState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () => context
                        .read<QuizBloc>()
                        .add(OnQuizMediaChanged(context)),
                    child: ImageCover(media: state.quiz.media),
                  );
                },
              ),
              const SizedBox(
                height: AppConstant.kPadding,
              ),
              QuizFormField(
                hintText: 'Name',
                maxLength: 50,
                onChanged: (title) =>
                    context.read<QuizBloc>().add(OnQuizTitleChanged(title)),
              ),
              const SizedBox(
                height: AppConstant.kPadding,
              ),
              QuizFormField(
                hintText: 'Description',
                maxLines: 6,
                maxLength: 500,
                onChanged: (desc) =>
                    context.read<QuizBloc>().add(OnQuizDescriptionChange(desc)),
              ),
              const SizedBox(
                height: AppConstant.kPadding,
              ),
              BlocBuilder<QuizCollectionBloc, QuizCollectionState>(
                builder: (context, state) {
                  return QuizCollectionDropDownField(
                    onChanged: (collectionId) {
                      context
                          .read<QuizBloc>()
                          .add(OnQuizCollectionChanged(collectionId as String));
                    },
                    label: const Text('Collection'),
                    items:
                        state is QuizCollectionSuccess ? state.collections : [],
                  );
                },
              ),
              const SizedBox(
                height: AppConstant.kPadding,
              ),
              QuizVisibilityTextField(
                onChanged: (val) => context
                    .read<QuizBloc>()
                    .add(OnQuizVisibilityChanged(val as String)),
                label: const Text('Visibility'),
              ),
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
            BlocBuilder<QuizBloc, QuizState>(
              builder: (context, state) {
                return state.isLoading
                    ? const Expanded(
                        // child: ElevatedButton.icon(
                        //   onPressed: () {},
                        //   icon: const CircularProgressIndicator.adaptive(),
                        //   label: Text(
                        //     'Loading',
                        //     style: AppConstant.textHeading.copyWith(
                        //       fontSize: 14.sp,
                        //     ),
                        //   ),
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.white,
                        //     elevation: 4,
                        //   ),
                        // ),
                        child: LoadingButton(label: 'Loading'),
                      )
                    : Expanded(
                        // child: ElevatedButton(
                        //   onPressed: state.isValid
                        //       ? () => context
                        //           .read<QuizBloc>()
                        //           .add(OnInitialNewQuiz(context))
                        //       : null,
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.white,
                        //     elevation: 4,
                        //   ),
                        //   child: Text(
                        //     'Save',
                        //     style: AppConstant.textHeading.copyWith(
                        //       fontSize: 14.sp,
                        //     ),
                        //   ),
                        // ),
                        child: CustomButton(
                          onPressed: state.isValid
                              ? () => context
                                  .read<QuizBloc>()
                                  .add(OnInitialNewQuiz(context))
                              : null,
                          label: 'Save',
                        ),
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}
