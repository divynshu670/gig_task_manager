import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import '../../domain/entities/user.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/use_cases/get_user.dart';
import '../../domain/use_cases/user_login.dart';
import '../../domain/use_cases/user_signup.dart';
import '../../data/repository/auth_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final getUserUseCaseProvider = Provider<GetUser>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return GetUser(repository: repo);
});

final userLoginUseCaseProvider = Provider<UserLogin>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return UserLogin(repository: repo);
});

final userSignupUseCaseProvider = Provider<UserSignup>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return UserSignup(repository: repo);
});

final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final getUser = ref.watch(getUserUseCaseProvider);
  return getUser.stream;
});

enum AuthStatus { idle, loading, success, error }

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final UserLogin _loginUseCase;
  final UserSignup _signupUseCase;
  final AuthRepository _repository;

  AuthNotifier({
    required UserLogin loginUseCase,
    required UserSignup signupUseCase,
    required AuthRepository repository,
  })  : _loginUseCase = loginUseCase,
        _signupUseCase = signupUseCase,
        _repository = repository,
        super(const AsyncData(null));

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      await _loginUseCase.loginWithEmail(email: email, password: password);
      state = const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e, StackTrace.current);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Google Sign-In
  Future<void> loginWithGoogle() async {
    state = const AsyncLoading();
    try {
      await _loginUseCase.loginWithGoogle();
      state = const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e, StackTrace.current);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> loginWithFacebook() async {
    state = const AsyncLoading();
    try {
      await _loginUseCase.loginWithFacebook();
      state = const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e, StackTrace.current);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      await _signupUseCase.signUpWithEmail(email: email, password: password);
      state = const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e, StackTrace.current);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<String?> resetPassword({required String email}) async {
    try {
      await _repository.resetPassword(email: email);
      return null; // null means success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  final loginUseCase = ref.watch(userLoginUseCaseProvider);
  final signupUseCase = ref.watch(userSignupUseCaseProvider);
  final repo = ref.watch(authRepositoryProvider);
  return AuthNotifier(
    loginUseCase: loginUseCase,
    signupUseCase: signupUseCase,
    repository: repo,
  );
});
