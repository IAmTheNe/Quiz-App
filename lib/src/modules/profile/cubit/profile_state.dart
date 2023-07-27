part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.user = AppUser.empty,
    this.quizzies = const [],
    this.isLoading = false,
  });

  final AppUser user;
  final List<Quiz> quizzies;
  final bool isLoading;

  @override
  List<Object?> get props => [
        user,
        quizzies,
        isLoading,
      ];

  copyWith({
    AppUser? user,
    List<Quiz>? quizzies,
    bool? isLoading,
  }) {
    return ProfileState(
      user: user ?? this.user,
      quizzies: quizzies ?? this.quizzies,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
