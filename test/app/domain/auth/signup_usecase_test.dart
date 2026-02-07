import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/core/failure/failure.dart';
import 'package:spotify/domain/params/auth/signup_params.dart';
import 'package:spotify/domain/repository/auth/auth_repositoy.dart';
import 'package:spotify/domain/usecases/auth/signup_usecase.dart';

import 'signup_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignupUseCase useCase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    useCase = SignupUseCase(repository);
  });

  group('SignupUseCase', () {
    test('should return Right when signup is successful', () async {
      // Arrange
      final params = SignupParams.create(
        fullName: 'Test User',
        email: 'test@test.com',
        password: '123456',
      );

      const response = 'Signup was Successfully';

      when(repository.signup(any))
          .thenAnswer((_) async => const Right(response));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, const Right(response));
      verify(repository.signup(any)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return Failure when signup fails', () async {
      // Arrange
      final params = SignupParams.create(
        fullName: 'Test User',
        email: 'test@test.com',
        password: '123456',
      );

      final failure = Failure('Signup failed');

      when(repository.signup(any)).thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, Left(failure));
      verify(repository.signup(any)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return Failure when params are null', () async {
      // Act
      final result = await useCase(null);

      // Assert
      expect(result, isA<Left>());
      verifyZeroInteractions(repository);
    });
  });
}
