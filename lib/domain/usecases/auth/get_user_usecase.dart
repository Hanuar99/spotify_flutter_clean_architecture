import 'package:dartz/dartz.dart';
import 'package:spotify/core/failure/failure.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/entities/auth/user_entity.dart';
import 'package:spotify/domain/repository/auth/auth_repositoy.dart';

class GetUserUseCase implements NoParamsUseCase<Either<Failure, UserEntity>> {
  final AuthRepository authRepository;

  GetUserUseCase(this.authRepository);
  @override
  Future<Either<Failure, UserEntity>> call() async {
    return authRepository.getUser();
  }
}
