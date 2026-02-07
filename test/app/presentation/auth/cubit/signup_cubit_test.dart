import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/core/failure/failure.dart';
import 'package:spotify/domain/usecases/auth/signup_usecase.dart';
import 'package:spotify/presentation/auth/cubits/signup/signup_cubit.dart';

import 'signup_cubit_test.mocks.dart';

@GenerateMocks([SignupUseCase])
void main() {
  late MockSignupUseCase mockSignupUseCase;
  late SignupCubit signupCubit;

  setUp(() {
    mockSignupUseCase = MockSignupUseCase();
    signupCubit = SignupCubit(mockSignupUseCase);
  });

  tearDown(() {
    signupCubit.close();
  });

  test('estado inicial es SignupInitial', () {
    expect(signupCubit.state, SignupInitial());
  });

  blocTest<SignupCubit, SignupState>(
    'emite [SignupLoading, SignupSuccess] cuando signup es exitoso',
    build: () {
      when(
        mockSignupUseCase.call(
          any,
        ),
      ).thenAnswer((_) async => const Right(''));

      return signupCubit;
    },
    act: (cubit) => cubit.signup(
      fullName: 'Juan',
      email: 'juan@mail.com',
      password: '123456',
    ),
    expect: () => [
      SignupLoading(),
      SignupSuccess(),
    ],
  );

  blocTest<SignupCubit, SignupState>(
    'emite [SignupLoading, SignupError] cuando signup falla',
    build: () {
      when(
        mockSignupUseCase.call(
          any,
        ),
      ).thenAnswer(
        (_) async => const Left(
          Failure('Error al registrar'),
        ),
      );

      return signupCubit;
    },
    act: (cubit) => cubit.signup(
      fullName: 'Juan',
      email: 'juan@mail.com',
      password: '123456',
    ),
    expect: () => [
      SignupLoading(),
      SignupError('Error al registrar'),
    ],
  );
}
