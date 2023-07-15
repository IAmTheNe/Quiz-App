import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    this.email,
    this.name,
    this.avatar,
    this.phoneNumber,
  });

  final String id;
  final String? email;
  final String? name;
  final String? avatar;
  final String? phoneNumber;

  /// Empty user which represents an unauthenticated user
  static const empty = User(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != empty;

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        avatar,
        phoneNumber,
      ];
}
