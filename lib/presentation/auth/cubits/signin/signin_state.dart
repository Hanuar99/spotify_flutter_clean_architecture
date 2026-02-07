part of 'signin_cubit.dart';

sealed class SigninState extends Equatable {
  const SigninState();

  @override
  List<Object?> get props => [];
}

class SigninInitial extends SigninState {
  const SigninInitial();
}

class SigninLoading extends SigninState {
  const SigninLoading();
}

class SigninSuccess extends SigninState {
  const SigninSuccess();
}

class SigninError extends SigninState {
  final String message;

  const SigninError(this.message);

  @override
  List<Object?> get props => [message];
}
