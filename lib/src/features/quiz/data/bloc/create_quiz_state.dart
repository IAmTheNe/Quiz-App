part of 'create_quiz_cubit.dart';

class CreateQuizState extends Equatable {
  const CreateQuizState({
    this.quiz = const Quiz(),
    this.isValid = false,
    this.isLoading = false,
    this.index = -1,
  });

  final bool isValid;
  final bool isLoading;
  final Quiz quiz;
  final int index;

  @override
  List<Object?> get props => [
        quiz,
        isValid,
        isLoading,
        index,
      ];

  CreateQuizState copyWith({
    Quiz? quiz,
    bool? isValid,
    bool? isLoading,
    int? index,
  }) {
    return CreateQuizState(
      quiz: quiz ?? this.quiz,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      index: index ?? this.index,
    );
  }
}
