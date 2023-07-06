part of 'create_quiz_cubit.dart';

class CreateQuizState extends Equatable {
  const CreateQuizState({
    this.title = '',
    this.description = '',
    this.visibility = QuizVisibility.public,
    this.keywords = const [],
    this.isValid = false,
    this.isLoading = false,
  });

  final String title;
  final String description;
  final QuizVisibility visibility;
  final List<String>? keywords;
  final bool isValid;
  final bool isLoading;

  @override
  List<Object?> get props => [
        title,
        description,
        keywords,
        isValid,
        visibility,
        isLoading,
      ];

  CreateQuizState copyWith({
    String? title,
    String? description,
    List<String>? keywords,
    bool? isValid,
    QuizVisibility? visibility,
    bool? isLoading,
  }) {
    return CreateQuizState(
      title: title ?? this.title,
      description: description ?? this.description,
      keywords: keywords ?? this.keywords,
      isValid: isValid ?? this.isValid,
      visibility: visibility ?? this.visibility,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
