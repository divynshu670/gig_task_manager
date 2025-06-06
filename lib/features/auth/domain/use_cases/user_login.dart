import '../entities/user.dart';
import '../repository/auth_repository.dart';

class UserLogin {
  final AuthRepository repository;

  UserLogin({required this.repository});

  Future<UserEntity> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await repository.loginWithEmail(email: email, password: password);
  }

  Future<UserEntity> loginWithGoogle() async {
    return await repository.loginWithGoogle();
  }

  Future<UserEntity> loginWithFacebook() async {
    return await repository.loginWithFacebook();
  }
}
