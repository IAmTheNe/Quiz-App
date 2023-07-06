import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/features/create/data/models/quiz.dart';
import 'package:whizz/src/features/create/data/repositories/create_quiz_repository.dart';

part 'create_quiz_state.dart';

class CreateQuizCubit extends Cubit<CreateQuizState> {
  CreateQuizCubit({CreateQuizRepository? quizRepository})
      : _quizRepository = quizRepository ?? CreateQuizRepository(),
        super(const CreateQuizState());

  final CreateQuizRepository _quizRepository;

  void nameChanged(String value) {
    emit(state.copyWith(
      title: value,
      isValid: value.isNotEmpty,
    ));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(
      description: value,
    ));
  }

  void visibilityChanged(String value) {
    final visibility =
        value == 'private' ? QuizVisibility.private : QuizVisibility.public;
    emit(state.copyWith(
      visibility: visibility,
    ));
  }

  Future<void> createQuiz() async {
    emit(state.copyWith(isLoading: true));
    final quiz = Quiz(
      title: state.title,
      description: state.description,
      visibility: state.visibility,
    );

    await _quizRepository.createNewQuiz(quiz);
    emit(state.copyWith(isLoading: false));
  }
}
