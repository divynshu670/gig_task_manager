import '../entities/user.dart';

abstract class AuthRepository {
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<UserEntity> loginWithEmail({
    required String email,
    required String password,
  });

  Future<UserEntity> loginWithGoogle();

  Future<UserEntity> loginWithFacebook();

  Future<void> resetPassword({required String email});

  Future<void> logout();

  Stream<UserEntity?> get authStateStream;

  UserEntity? getCurrentUser();
}
