import 'package:dartz/dartz.dart';
import 'package:spotify/core/failure/failure.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/data/dtos/auth/create_user_dto.dart';
import 'package:spotify/domain/params/auth/signup_params.dart';
import 'package:spotify/domain/repository/auth/auth_repositoy.dart';

class SignupUseCase implements UseCase<Either<Failure, String>, SignupParams> {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SignupParams? params) {
    if (params == null) {
      return Future.value(Left(Failure('Missing params')));
    }

    return repository.signup(
      CreateUserDto.fromDomain(params),
    );
  }
}
