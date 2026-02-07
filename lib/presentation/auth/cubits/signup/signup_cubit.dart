import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/data/models/auth/create_user_req.dart';
import 'package:spotify/domain/usecases/auth/signup_usecase.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupUseCase signupUseCase;

  SignupCubit(this.signupUseCase) : super(SignupInitial());

  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(SignupLoading());

    final result = await signupUseCase.call(
      CreateUserReq(
        fullName: fullName,
        email: email,
        password: password,
      ),
    );

    result.fold(
      (l) => emit(SignupError(l.message)),
      (r) => emit(SignupSuccess()),
    );
  }
}
