import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';
import 'package:spotify/domain/repository/auth/auth_repositoy.dart';

class SigninUseCase implements UseCase<Either, SigninUserReq> {
  final AuthRepository authRepository;

  SigninUseCase(this.authRepository);
  @override
  Future<Either> call(SigninUserReq params) async {
    return authRepository.sigin(params);
  }
}
