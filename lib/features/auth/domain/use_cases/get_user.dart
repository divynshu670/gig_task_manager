import '../entities/user.dart';
import '../repository/auth_repository.dart';

class GetUser {
  final AuthRepository repository;

  GetUser({required this.repository});

  UserEntity? call() {
    return repository.getCurrentUser();
  }

  Stream<UserEntity?> get stream => repository.authStateStream;
}
