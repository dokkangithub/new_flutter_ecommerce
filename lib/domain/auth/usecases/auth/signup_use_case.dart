import 'package:dio/dio.dart';
import '../../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository authRepository;

  SignupUseCase(this.authRepository);

  Future<Response> call(Map<String, dynamic> userData) async {
    return await authRepository.signup(userData);
  }
}
