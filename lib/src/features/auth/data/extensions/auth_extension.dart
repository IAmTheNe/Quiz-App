import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:whizz/src/features/auth/data/models/user.dart';

extension FirebaseUser on firebase_auth.User {
  /// Maps a [firebase_auth.User] into a [User].
  User get toUser {
    return User(
      id: uid,
      email: email,
      name: displayName,
      avatar: photoURL,
    );
  }
}
