import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/features/quiz/data/bloc/quiz_cubit.dart';
import 'package:whizz/src/features/quiz/data/models/media.dart';
import 'package:whizz/src/router/app_router.dart';

class QuizController {
  static void intent({
    required BuildContext context,
    required void Function(Media) onResult,
  }) async {
    final result = await context.pushNamed<Media>(RouterPath.media.name);
    if (result?.imageUrl != null) {
      onResult(result!);
    }
  }

  static void createQuiz({
    required BuildContext context,
  }) {
    context.read<QuizCubit>().createQuiz().then(
          (_) => context.showSuccessDialog(
            title: 'Create Quiz Successfully!',
          ),
        );
  }
}
