import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/domain/usecases/auth/signin_usecase.dart';
import 'package:spotify/presentation/auth/cubits/signin/signin_cubit.dart';

import 'signin_cubit_test.mocks.dart';

@GenerateMocks([SigninUseCase])
void main() {
  late MockSigninUseCase useCase;
  late SigninCubit cubit;

  setUp(() {
    useCase = MockSigninUseCase();
    cubit = SigninCubit(signinUseCase: useCase);
  });

  tearDown(() => cubit.close());

  blocTest<SigninCubit, SigninState>(
    'emits [Loading, Success] when signin succeeds',
    build: () {
      when(useCase.call(any)).thenAnswer((_) async => Right(unit));
      return cubit;
    },
    act: (cubit) => cubit.signIn(
      email: 'test@test.com',
      password: '123456',
    ),
    expect: () => [
      SigninLoading(),
      SigninSuccess(),
    ],
  );

  blocTest<SigninCubit, SigninState>(
    'emits [Loading, Error] when signin fails',
    build: () {
      when(useCase.call(any))
          .thenAnswer((_) async => Left('Invalid credentials'));
      return cubit;
    },
    act: (cubit) => cubit.signIn(
      email: 'wrong@test.com',
      password: '123',
    ),
    expect: () => [
      SigninLoading(),
      SigninError('Invalid credentials'),
    ],
  );
}
