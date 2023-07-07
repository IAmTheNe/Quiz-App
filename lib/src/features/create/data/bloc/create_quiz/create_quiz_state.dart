part of 'create_quiz_cubit.dart';


class CreateQuizState extends Equatable {
  const CreateQuizState({
    this.quiz = const Quiz(),
    this.isValid = false,
    this.isLoading = false,
  });

  final bool isValid;
  final bool isLoading;
  final Quiz quiz;

  @override
  List<Object?> get props => [
        quiz,
        isValid,
        isLoading,
      ];

  CreateQuizState copyWith({
    Quiz? quiz,
    bool? isValid,
    bool? isLoading,
  }) {
    return CreateQuizState(
      quiz: quiz ?? this.quiz,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
