import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/common/modules/pick_image.dart';
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
      )
    ));
  }

  Future<void> createQuiz() async {
    emit(state.copyWith(isLoading: true));
    final quiz = state.quiz;
    try {
      await _quizRepository.createNewQuiz(quiz);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
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
}
