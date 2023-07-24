// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email ?? '',
      'name': name ?? '',
      'avatar': avatar ?? '',
      'phoneNumber': phoneNumber ?? '',
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
