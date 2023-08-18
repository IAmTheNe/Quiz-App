part of 'quiz_collection_cubit.dart';

sealed class QuizCollectionState {
  const QuizCollectionState();
}

class QuizCollectionInitial implements QuizCollectionState {
  const QuizCollectionInitial();
}

class QuizCollectionLoading implements QuizCollectionState {
  const QuizCollectionLoading();
}

class QuizCollectionSuccess implements QuizCollectionState {
  const QuizCollectionSuccess(this.collections);

  final List<QuizCollection> collections;
}

class QuizCollectionError implements QuizCollectionState {
  const QuizCollectionError(this.message);

  final String message;
}

class QuizDetailInfo implements QuizCollectionState {
  const QuizDetailInfo(this.quizzes);

  final List<Quiz> quizzes;
}
