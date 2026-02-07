import 'package:spotify/domain/entities/auth/user_entity.dart';

class UserModel extends UserEntity {
  UserModel(
      {required super.email, required super.fullName, required super.imageUrl});

  factory UserModel.fromJson(Map<String, dynamic> json, {String? imageUrl}) =>
      UserModel(
        email: json['email'],
        fullName: json['name'],
        imageUrl: imageUrl,
      );
}
