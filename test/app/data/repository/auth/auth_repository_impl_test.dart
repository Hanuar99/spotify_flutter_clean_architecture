import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/core/failure/failure.dart';
import 'package:spotify/data/dtos/auth/create_user_dto.dart';
import 'package:spotify/data/repository/auth/auth_repository_impl.dart';
import 'package:spotify/data/sources/auth/auth_firebase_service.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthFirebaseService])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthFirebaseService firebaseService;
  late CreateUserDto userReq;

  setUp(() {
    firebaseService = MockAuthFirebaseService();
    repository = AuthRepositoryImpl(
      authFirebaseService: firebaseService,
    );
    userReq = CreateUserDto(
      email: 'test@test.com',
      password: '123456',
      fullName: 'Test User',
    );
  });

  group('AuthRepositoryImpl - signup', () {
    test('should return Right<String> when signup succeeds', () async {
      // Arrange

      when(firebaseService.signup(userReq))
          .thenAnswer((_) async => const Right('user_id'));

      // Act
      final result = await repository.signup(userReq);

      // Assert
      expect(result, const Right('user_id'));
      verify(firebaseService.signup(userReq)).called(1);
      verifyNoMoreInteractions(firebaseService);
    });

    test('should return Failure when signup fails', () async {
      // Arrange
      final failure = Failure('Signup failed');

      when(firebaseService.signup(userReq))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await repository.signup(userReq);

      // Assert
      expect(result, Left(failure));
      verify(firebaseService.signup(userReq)).called(1);
      verifyNoMoreInteractions(firebaseService);
    });
  });
}
