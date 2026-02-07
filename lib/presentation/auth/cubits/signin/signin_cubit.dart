import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';
import 'package:spotify/domain/usecases/auth/signin_usecase.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final SigninUseCase signinUseCase;

  SigninCubit({required this.signinUseCase}) : super(SigninInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(SigninLoading());

    final result = await signinUseCase(
      SigninUserReq(
        email: email,
        password: password,
      ),
    );

    result.fold(
      (failure) => emit(SigninError(failure)),
      (_) => emit(SigninSuccess()),
    );
  }
}
