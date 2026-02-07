import 'package:dartz/dartz.dart';
import 'package:spotify/core/failure/failure.dart';
import 'package:spotify/data/dtos/auth/create_user_dto.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';
import 'package:spotify/domain/entities/auth/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> signup(CreateUserDto user);
  Future<Either> sigin(SigninUserReq user);

  Future<Either<Failure, UserEntity>> getUser();
  bool isLoggedIn();
}
