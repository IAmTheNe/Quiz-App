import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/widgets/quiz_textfield.dart';
import 'package:whizz/src/features/quiz/data/bloc/create_quiz_cubit.dart';
import 'package:whizz/src/features/quiz/data/models/quiz.dart';
import 'package:whizz/src/features/quiz/presentation/widgets/image_cover.dart';
import 'package:whizz/src/features/quiz/presentation/popups/popup_menu.dart';
import 'package:whizz/src/features/quiz/presentation/widgets/rainbow_container.dart';

import 'package:whizz/src/router/app_router.dart';

class CreateQuizScreen extends StatelessWidget {
  const CreateQuizScreen({super.key});

  void intent(BuildContext context) async {
    final result =
        await context.pushNamed<(String, AttachType)>(RouterPath.media.name);

    if (result?.$1 != null) {
      // ignore: use_build_context_synchronously
      context.read<CreateQuizCubit>().attachmentChanged(result);
    }
  }

  void createQuiz(BuildContext context) {
    context.read<CreateQuizCubit>().createQuiz().then((_) => context.pop());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quiz'),
        actions: const [
          CreateOptionsPopupMenu(),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Constants.kPadding),
          child: Column(
            children: [
              BlocBuilder<CreateQuizCubit, CreateQuizState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      intent(context);
                    },
                    child: state.quiz.imageUrl != null
                        ? ImageCover(
                            url: state.quiz.imageUrl!,
                            attachType: state.quiz.attachType,
                          )
                        : const RainbowContainer(),
                  );
                },
              ),
              const SizedBox(
                height: Constants.kPadding,
              ),
              QuizFormField(
                hintText: 'Name',
                maxLength: 50,
                onChanged: context.read<CreateQuizCubit>().nameChanged,
              ),
              const SizedBox(
                height: Constants.kPadding,
              ),
              QuizFormField(
                hintText: 'Description',
                maxLines: 6,
                maxLength: 500,
                onChanged: context.read<CreateQuizCubit>().descriptionChanged,
              ),
              const SizedBox(
                height: Constants.kPadding,
              ),
              QuizDropDownField(
                onChanged: (val) {},
                label: const Text('Collection'),
                items: const ['Holiday', 'Games', 'Sports', 'Music'],
              ),
              const SizedBox(
                height: Constants.kPadding,
              ),
              QuizDropDownField(
                onChanged: (val) {
                  context
                      .read<CreateQuizCubit>()
                      .visibilityChanged(val as String);
                },
                label: const Text('Visibility'),
                items: const ['Public', 'Private'],
              ),
              const SizedBox(
                height: Constants.kPadding,
              ),
              const QuizFormField(
                hintText: 'Keyword',
                maxLines: 6,
                maxLength: 1000,
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
                onPressed: () {
                  context.pushNamed(RouterPath.question.name);
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
            BlocBuilder<CreateQuizCubit, CreateQuizState>(
              builder: (context, state) {
                return state.isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : Expanded(
                        child: ElevatedButton(
                          onPressed:
                              state.isValid ? () => createQuiz(context) : null,
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
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
