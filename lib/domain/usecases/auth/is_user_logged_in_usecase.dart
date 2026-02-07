import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/auth/auth_repositoy.dart';

class IsUserLoggedInUseCase implements NoParamsUseCase<bool> {
  final AuthRepository authRepository;

  IsUserLoggedInUseCase(this.authRepository);
  @override
  Future<bool> call() async {
    return authRepository.isLoggedIn();
  }
}
