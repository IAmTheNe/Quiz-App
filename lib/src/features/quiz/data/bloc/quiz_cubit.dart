import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/common/modules/pick_image.dart';
import 'package:whizz/src/features/quiz/data/models/answer.dart';
import 'package:whizz/src/features/quiz/data/models/question.dart';
import 'package:whizz/src/features/quiz/data/models/quiz.dart';
import 'package:whizz/src/features/quiz/data/repositories/quiz_repository.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit({QuizRepository? quizRepository})
      : _quizRepository = quizRepository ?? QuizRepository(),
        super(const QuizState());

  final QuizRepository _quizRepository;

  void nameChanged(String value) {
    emit(state.copyWith(
      quiz: state.quiz.copyWith(
        title: value,
      ),
      isValid: value.isNotEmpty,
    ));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(
      quiz: state.quiz.copyWith(
        description: value,
      ),
    ));
  }

  void visibilityChanged(String value) {
    final visibility =
        value == 'private' ? QuizVisibility.private : QuizVisibility.public;
    emit(state.copyWith(
      quiz: state.quiz.copyWith(
        visibility: visibility,
      ),
    ));
  }

  void attachmentChanged((String, AttachType)? value) {
    emit(state.copyWith(
        quiz: state.quiz.copyWith(
      imageUrl: value?.$1,
      attachType: value?.$2,
    )));
  }

  Future<void> createQuiz() async {
    emit(state.copyWith(isLoading: true));
    final quiz = state.quiz;
    try {
      await _quizRepository.createNewQuiz(quiz);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> onPickImage() async {
    final image = await PickImage.pickImage();
    emit(state.copyWith(
      quiz: state.quiz.copyWith(
        imageUrl: image!.path,
      ),
    ));
  }

  Future<void> onTakePhoto() async {
    final image = await PickImage.takePhoto();
    emit(state.copyWith(
        quiz: state.quiz.copyWith(
      attachType: AttachType.local,
      imageUrl: image!.path,
    )));
  }

  Future<void> onSelectedOnlineImage(String url) async {
    emit(state.copyWith(
        quiz: state.quiz.copyWith(
      attachType: AttachType.online,
      imageUrl: url,
    )));
  }

  void indexChanged(int index) {
    emit(state.copyWith(index: index));
  }

  void questionNameChanged({
    required String? name,
  }) {
    final updatedList = List<Question>.from(state.quiz.questions);
    updatedList[state.index] = updatedList[state.index].copyWith(
      name: name,
    );

    emit(
      state.copyWith(
        quiz: state.quiz.copyWith(
          questions: updatedList,
        ),
      ),
    );
  }

  void questionAnswerChanged({
    required String answer,
    required int index,
  }) {
    final updateListQuestion = List<Question>.from(state.quiz.questions);

    final updateListAnswer =
        List<Answer>.from(updateListQuestion[state.index].answers);

    updateListAnswer[index] = updateListAnswer[index].copyWith(
      answer: answer,
    );

    updateListQuestion[state.index] = updateListQuestion[state.index].copyWith(
      answers: updateListAnswer,
    );

    emit(state.copyWith(
      quiz: state.quiz.copyWith(questions: updateListQuestion),
    ));
  }

  void questionAnswerStatusChanged({
    required int index,
    bool isCorrect = false,
  }) {
    final updateListQuestion = List<Question>.from(state.quiz.questions);

    final updateListAnswer =
        List<Answer>.from(updateListQuestion[state.index].answers);

    updateListAnswer[index] = updateListAnswer[index].copyWith(
      isCorrect: isCorrect,
    );

    updateListQuestion[state.index] = updateListQuestion[state.index].copyWith(
      answers: updateListAnswer,
    );

    emit(state.copyWith(
      quiz: state.quiz.copyWith(questions: updateListQuestion),
    ));
  }

  ///
  void createNewQuestion() {
    final question = Question(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      answers: List.generate(4, (_) => const Answer.empty()),
    );
    emit(
      state.copyWith(
        quiz: state.quiz.copyWith(
          questions: state.quiz.questions.isNotEmpty
              ? [...state.quiz.questions, question]
              : [question],
        ),
        index: state.quiz.questions.length,
      ),
    );
  }
}
