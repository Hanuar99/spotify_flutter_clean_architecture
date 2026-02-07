import 'package:equatable/equatable.dart';

class SignupParams extends Equatable {
  final String fullName;
  final String email;
  final String password;

  const SignupParams._({
    required this.fullName,
    required this.email,
    required this.password,
  });

  static SignupParams create({
    required String fullName,
    required String email,
    required String password,
  }) {
    if (fullName.trim().isEmpty) {
      throw ArgumentError('Full name cannot be empty');
    }

    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email');
    }

    if (password.length < 6) {
      throw ArgumentError('Password too weak');
    }

    return SignupParams._(
      fullName: fullName.trim(),
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  static bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  @override
  List<Object> get props => [fullName, email, password];
}
