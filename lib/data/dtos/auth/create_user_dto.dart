import 'package:spotify/domain/params/auth/signup_params.dart';

class CreateUserDto {
  final String fullName;
  final String email;
  final String password;

  const CreateUserDto({
    required this.fullName,
    required this.email,
    required this.password,
  });

  factory CreateUserDto.fromDomain(SignupParams params) {
    return CreateUserDto(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': fullName,
      'email': email,
    };
  }
}
