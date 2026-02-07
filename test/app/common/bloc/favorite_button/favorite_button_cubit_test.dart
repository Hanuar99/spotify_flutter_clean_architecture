import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:spotify/domain/usecases/song/add_or_remove_favorite_usecase.dart';

import 'favorite_button_cubit_test.mocks.dart';

@GenerateMocks([AddOrRemoveFavoriteUsecase])
void main() {
  late FavoriteButtonCubit favoriteButtonCubit;
  late AddOrRemoveFavoriteUsecase addOrRemoveFavoriteUsecase;

  setUp(() {
    addOrRemoveFavoriteUsecase = MockAddOrRemoveFavoriteUsecase();
    favoriteButtonCubit = FavoriteButtonCubit(addOrRemoveFavoriteUsecase);
  });

  tearDown(() {
    favoriteButtonCubit.close();
  });

  test('estado inicial es FavoriteButtonInitial', () {
    expect(favoriteButtonCubit.state, isA<FavoriteButtonInitial>());
  });

  blocTest<FavoriteButtonCubit, FavoriteButtonState>(
    'emite [FavoriteButtonUpdated] cuando el usecase retorna true',
    build: () {
      when(addOrRemoveFavoriteUsecase.call('1'))
          .thenAnswer((_) async => Right(true));
      return favoriteButtonCubit;
    },
    act: (cubit) => cubit.favoriteButtonUpdate('1'),
    expect: () => [isA<FavoriteButtonUpdated>()],
    verify: (_) {
      verify(addOrRemoveFavoriteUsecase.call('1')).called(1);
    },
  );
}
