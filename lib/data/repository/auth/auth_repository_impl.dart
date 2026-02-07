import 'package:dartz/dartz.dart';
import 'package:spotify/core/failure/failure.dart';
import 'package:spotify/data/dtos/auth/create_user_dto.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';
import 'package:spotify/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify/domain/entities/auth/user_entity.dart';
import 'package:spotify/domain/repository/auth/auth_repositoy.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthFirebaseService authFirebaseService;

  AuthRepositoryImpl({required this.authFirebaseService});
  @override
  Future<Either> sigin(SigninUserReq user) async {
    return await authFirebaseService.signin(user);
  }

  @override
  Future<Either<Failure, String>> signup(CreateUserDto user) async {
    return await authFirebaseService.signup(user);
  }

  @override
  Future<Either<Failure, UserEntity>> getUser() async {
    return await authFirebaseService.getUser();
  }

  @override
  bool isLoggedIn() {
    return authFirebaseService.isLoggedIn();
  }
}
