import '../../domain/entities/user.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/user_mode.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({AuthRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSource();

  @override
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _remoteDataSource.signUpWithEmail(
      email: email,
      password: password,
    );
    return UserModel.fromFirebase(credential.user!);
  }

  @override
  Future<UserEntity> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _remoteDataSource.loginWithEmail(
      email: email,
      password: password,
    );
    return UserModel.fromFirebase(credential.user!);
  }

  @override
  Future<UserEntity> loginWithGoogle() async {
    final credential = await _remoteDataSource.signInWithGoogle();
    return UserModel.fromFirebase(credential.user!);
  }

  @override
  Future<UserEntity> loginWithFacebook() async {
    final credential = await _remoteDataSource.signInWithFacebook();
    return UserModel.fromFirebase(credential.user!);
  }

  @override
  Future<void> resetPassword({required String email}) async {
    return await _remoteDataSource.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> logout() async {
    return await _remoteDataSource.signOut();
  }

  @override
  Stream<UserEntity?> get authStateStream {
    return _remoteDataSource.authStateChanges.map((firebaseUser) {
      if (firebaseUser == null) return null;
      return UserModel.fromFirebase(firebaseUser);
    });
  }

  @override
  UserEntity? getCurrentUser() {
    final firebaseUser = _remoteDataSource.currentUser;
    if (firebaseUser == null) return null;
    return UserModel.fromFirebase(firebaseUser);
  }
}
