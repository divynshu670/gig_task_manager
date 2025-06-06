import '../entities/user.dart';
import '../repository/auth_repository.dart';

class UserSignup {
  final AuthRepository repository;

  UserSignup({required this.repository});

  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await repository.signUpWithEmail(email: email, password: password);
  }
}
