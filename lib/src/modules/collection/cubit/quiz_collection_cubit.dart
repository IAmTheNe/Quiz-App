import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/modules/collection/model/quiz_collection.dart';
import 'package:whizz/src/modules/collection/repository/quiz_collection_repository.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';

part 'quiz_collection_state.dart';

class QuizCollectionCubit extends Cubit<QuizCollectionState> {
  QuizCollectionCubit({QuizCollectionRepository? repository})
      : _repository = repository ?? QuizCollectionRepository(),
        super(const QuizCollectionInitial()) {
    onGetCollection();
  }

  final QuizCollectionRepository _repository;

  void onGetCollection() async {
    emit(const QuizCollectionLoading());
    try {
      final result = await _repository.fetchAllCollections();
      emit(QuizCollectionSuccess(result));
    } catch (e) {
      log(e.toString());
      emit(QuizCollectionError(e.toString()));
    }
  }

  Future<List<Quiz>> onGetQuizByCollectionId(String collectionId) async {
    final result = await _repository.collectionByID(collectionId);
    return result;
  }
}
