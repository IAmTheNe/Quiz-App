import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/common/modules/pick_image.dart';
import 'package:whizz/src/features/quiz/data/models/answer.dart';
import 'package:whizz/src/features/quiz/data/models/media.dart';
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

  void attachmentChanged(Media value) {
    emit(state.copyWith(
        quiz: state.quiz.copyWith(
      media: value,
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
    emit(
      state.copyWith(
        quiz: state.quiz.copyWith(
          // imageUrl: image!.path,
          media: Media(
            imageUrl: image!.path,
            type: AttachType.local,
          ),
        ),
      ),
    );
  }

  Future<void> onTakePhoto() async {
    final image = await PickImage.takePhoto();
    emit(
      state.copyWith(
        quiz: state.quiz.copyWith(
          media: Media(
            imageUrl: image!.path,
            type: AttachType.local,
          ),
        ),
      ),
    );
  }

  Future<void> onSelectedOnlineImage(String url) async {
    emit(
      state.copyWith(
        quiz: state.quiz.copyWith(
          media: Media(
            imageUrl: url,
            type: AttachType.online,
          ),
        ),
      ),
    );
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

  void questionMediaChanged(Media media) {
    final updatedList = List<Question>.from(state.quiz.questions);
    updatedList[state.index] = updatedList[state.index].copyWith(
      media: media,
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
    required bool isCorrect,
  }) {
    final updateListQuestion = List<Question>.from(state.quiz.questions);

    final updateListAnswer =
        List<Answer>.from(updateListQuestion[state.index].answers);

    updateListAnswer[index] = updateListAnswer[index].copyWith(
      isCorrect: !updateListAnswer[index].isCorrect,
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
          questions: List.from(state.quiz.questions)..add(question),
        ),
        index: state.quiz.questions.length,
      ),
    );
  }

  void removeQuestion() {
    // final question = Question(
    //   id: DateTime.now().millisecondsSinceEpoch.toString(),
    //   answers: List.generate(4, (_) => const Answer.empty()),
    // );
    emit(
      state.copyWith(
        quiz: state.quiz.copyWith(
          questions: List.from(state.quiz.questions)..removeAt(state.index),
        ),
        index: 0,
      ),
    );
  }
}
