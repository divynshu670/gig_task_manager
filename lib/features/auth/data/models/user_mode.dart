import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user.dart' as domain;

class UserModel extends domain.UserEntity {
  const UserModel({
    required String uid,
    required String? email,
    required String? displayName,
    required String? photoUrl,
  }) : super(
            uid: uid,
            email: email,
            displayName: displayName,
            photoUrl: photoUrl);

  factory UserModel.fromFirebase(User firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
    );
  }
}
