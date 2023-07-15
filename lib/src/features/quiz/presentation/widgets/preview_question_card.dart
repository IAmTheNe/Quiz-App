import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/features/quiz/data/bloc/create_quiz_cubit.dart';
import 'package:whizz/src/features/quiz/data/models/question.dart';

class PreviewQuestionCard extends StatelessWidget {
  const PreviewQuestionCard({super.key, required this.questions});

  final List<Question> questions;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            BlocBuilder<CreateQuizCubit, CreateQuizState>(
              builder: (context, state) {
                return Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  spacing: Constants.kPadding,
                  direction: Axis.horizontal,
                  children: List.generate(
                    questions.length,
                    (index) => GestureDetector(
                      onTap: () {
                        context.read<CreateQuizCubit>().indexChanged(index);
                      },
                      child: CircleAvatar(
                        backgroundColor: state.index != index
                            ? Colors.grey.shade300
                            : Colors.lightBlue.shade600,
                        child: Text(
                          '${index + 1}',
                        ),
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
