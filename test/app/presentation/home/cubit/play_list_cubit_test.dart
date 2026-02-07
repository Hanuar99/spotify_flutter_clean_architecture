import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/domain/usecases/song/get_play_list_usecase.dart';
import 'package:spotify/presentation/home/cubit/play_list_cubit.dart';

import 'play_list_cubit_test.mocks.dart';

@GenerateMocks([GetPlayListUseCase])
void main() {
  late PlayListCubit cubit;
  late MockGetPlayListUseCase mockGetPlayListUseCase;

  setUp(() {
    mockGetPlayListUseCase = MockGetPlayListUseCase();
    cubit = PlayListCubit(mockGetPlayListUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('estado inicial es PlayListLoading', () {
    expect(cubit.state, isA<PlayListLoading>());
  });

  blocTest<PlayListCubit, PlayListState>(
    'emite [PlayListLoaded] cuando el usecase retorna playlist',
    build: () {
      when(mockGetPlayListUseCase.call())
          .thenAnswer((_) async => Right(<SongEntity>[]));
      return cubit;
    },
    act: (cubit) => cubit.getPlayList(),
    expect: () => [
      isA<PlayListLoaded>(),
    ],
    verify: (_) {
      verify(mockGetPlayListUseCase.call()).called(1);
    },
  );

  blocTest<PlayListCubit, PlayListState>(
    'emite [PlayListError] cuando el usecase retorna error',
    build: () {
      when(mockGetPlayListUseCase.call())
          .thenAnswer((_) async => Left('error'));
      return cubit;
    },
    act: (cubit) => cubit.getPlayList(),
    expect: () => [
      isA<PlayListError>(),
    ],
  );
}
