part of 'quiz_collection_bloc.dart';

sealed class QuizCollectionEvent {
  const QuizCollectionEvent();
}

class GetDataEvent implements QuizCollectionEvent {
  const GetDataEvent();
}

class SearchDataEvent implements QuizCollectionEvent {
  const SearchDataEvent(this.data);

  final String data;
}
