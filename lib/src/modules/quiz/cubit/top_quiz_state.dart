// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'top_quiz_cubit.dart';

class TopQuizState extends Equatable {
  const TopQuizState({
    this.quiz = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  final List<Quiz> quiz;
  final bool isLoading;
  final String errorMessage;

  @override
  List<Object> get props => [
        quiz,
        isLoading,
        errorMessage,
      ];

  TopQuizState copyWith({
    List<Quiz>? quiz,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TopQuizState(
      quiz: quiz ?? this.quiz,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
