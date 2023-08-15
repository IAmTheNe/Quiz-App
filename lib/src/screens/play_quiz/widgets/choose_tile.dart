import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/modules/play/cubit/play_cubit.dart';
import 'package:whizz/src/modules/quiz/model/answer.dart';

class ChooseTile extends StatelessWidget {
  const ChooseTile({
    super.key,
    required this.answers,
    required this.state,
  });

  final List<Answer> answers;
  final GameState state;

  final listColors = const [
    Color(0xFFe35454),
    Color(0xFF30b0c7),
    Color(0xFFff9500),
    Color(0xFF3ed684),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        childAspectRatio: 16 / 9,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: state.answers[state.currentQuestion] == null
              ? () {
                  context.read<GameCubit>().chooseAnswer(index);
                }
              : null,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(AppConstant.kPadding / 2),
            decoration: BoxDecoration(
              color: state.answers[state.currentQuestion] != index
                  ? listColors[index]
                  : Colors.tealAccent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              answers[index].answer,
              style: AppConstant.textSubtitle.copyWith(
                color: state.answers[state.currentQuestion] != index
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.w700,
              ),
              maxLines: null,
              textAlign: TextAlign.justify,
              overflow: TextOverflow.visible,
            ),
          ),
        );
      },
    );
  }
}
