import '../repositories/auth_repository.dart';

class SignInWithApple {
  const SignInWithApple(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.signInWithApple();
}
