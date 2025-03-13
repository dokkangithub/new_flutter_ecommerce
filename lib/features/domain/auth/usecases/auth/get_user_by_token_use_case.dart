import '../../../../data/auth/models/auth_response_model.dart';
import '../../repositories/auth_repository.dart';

class GetUserByTokenUseCase {
  final AuthRepository authRepository;

  GetUserByTokenUseCase(this.authRepository);

  Future<AuthResponseModel> call(String token) async {
    return await authRepository.getUserByToken(token);
  }
}
