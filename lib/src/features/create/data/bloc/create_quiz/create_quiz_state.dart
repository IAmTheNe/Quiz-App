part of 'create_quiz_cubit.dart';

enum AttachType { local, online }

class CreateQuizState extends Equatable {
  const CreateQuizState({
    this.title = '',
    this.description = '',
    this.visibility = QuizVisibility.public,
    this.keywords = const [],
    this.imagePath,
    this.attach,
    this.isValid = false,
    this.isLoading = false,
  });

  final String title;
  final String description;
  final QuizVisibility visibility;
  final List<String>? keywords;
  final String? imagePath;
  final bool isValid;
  final bool isLoading;
  final AttachType? attach;

  @override
  List<Object?> get props => [
        title,
        description,
        keywords,
        imagePath,
        attach,
        isValid,
        visibility,
        isLoading,
      ];

  CreateQuizState copyWith({
    String? title,
    String? description,
    List<String>? keywords,
    String? imagePath,
    AttachType? attach,
    bool? isValid,
    QuizVisibility? visibility,
    bool? isLoading,
  }) {
    return CreateQuizState(
      title: title ?? this.title,
      description: description ?? this.description,
      keywords: keywords ?? this.keywords,
      imagePath: imagePath ?? this.imagePath,
      attach: attach ?? this.attach,
      isValid: isValid ?? this.isValid,
      visibility: visibility ?? this.visibility,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
