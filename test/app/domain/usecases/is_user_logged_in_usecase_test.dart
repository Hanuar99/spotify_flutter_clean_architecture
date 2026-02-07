import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/domain/usecases/auth/is_user_logged_in_usecase.dart';

import '../../../mocks.dart';

void main() {
  late IsUserLoggedInUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = IsUserLoggedInUseCase(mockAuthRepository);
  });

  test('should return TRUE when user is logged in', () async {
    // arrange
    when(mockAuthRepository.isLoggedIn()).thenReturn(true);

    // act
    final result = await useCase.call();

    // assert
    expect(result, true);
    verify(mockAuthRepository.isLoggedIn()).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return FALSE when user is not logged in', () async {
    // arrange
    when(mockAuthRepository.isLoggedIn()).thenReturn(false);

    // act
    final result = await useCase.call();

    // assert
    expect(result, false);
    verify(mockAuthRepository.isLoggedIn()).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
