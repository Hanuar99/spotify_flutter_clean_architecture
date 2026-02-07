import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/core/failure/failure.dart';
import 'package:spotify/domain/entities/auth/user_entity.dart';
import 'package:spotify/domain/usecases/auth/get_user_usecase.dart';
import 'package:spotify/presentation/profile/blocs/profile_info_cubit/profile_info_cubit.dart';

import 'profile_info_cubit_test.mocks.dart';

@GenerateMocks([GetUserUseCase])
void main() {
  late ProfileInfoCubit cubit;
  late MockGetUserUseCase getUserUseCase;

  setUp(() {
    getUserUseCase = MockGetUserUseCase();
    cubit = ProfileInfoCubit(getUserUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('estado inicial es ProfileInfoLoading', () {
    expect(cubit.state, isA<ProfileInfoLoading>());
  });

  blocTest<ProfileInfoCubit, ProfileInfoState>(
    'emite [ProfileInfoLoaded] cuando el usecase retorna un usuario',
    build: () {
      when(getUserUseCase.call()).thenAnswer((_) async => Right(UserEntity()));
      return cubit;
    },
    act: (cubit) => cubit.getUser(),
    expect: () => [isA<ProfileInfoLoaded>()],
    verify: (_) {
      verify(getUserUseCase.call()).called(1);
    },
  );

  blocTest<ProfileInfoCubit, ProfileInfoState>(
    'emite [ProfileInfoError] cuando el usecase retorna un error',
    build: () {
      when(getUserUseCase.call())
          .thenAnswer((_) async => Left(Failure('error')));
      return cubit;
    },
    act: (cubit) => cubit.getUser(),
    expect: () => [isA<ProfileInfoError>()],
    verify: (_) {
      verify(getUserUseCase.call()).called(1);
    },
  );
}
