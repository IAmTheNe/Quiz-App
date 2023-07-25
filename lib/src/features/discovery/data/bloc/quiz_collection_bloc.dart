import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/features/discovery/data/models/quiz_collection.dart';
import 'package:whizz/src/features/discovery/data/repositories/quiz_collection_repository.dart';

part 'quiz_collection_event.dart';
part 'quiz_collection_state.dart';

class QuizCollectionBloc
    extends Bloc<QuizCollectionEvent, QuizCollectionState> {
  QuizCollectionBloc({QuizCollectionRepository? repository})
      : _repository = repository ?? QuizCollectionRepository(),
        super(const QuizCollectionInitial()) {
    on(_onGetCollection);
  }

  final QuizCollectionRepository _repository;

  void _onGetCollection(
    GetDataEvent event,
    Emitter<QuizCollectionState> emit,
  ) async {
    emit(const QuizCollectionLoading());
    try {
      final result = await _repository.fetchAllCollections();
      emit(QuizCollectionSuccess(result));
    } catch (e) {
      log(e.toString());
      emit(QuizCollectionError(e.toString()));
    }
  }
}
