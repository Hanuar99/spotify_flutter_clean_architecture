import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/domain/usecases/song/get_news_songs_usecase.dart';
import 'package:spotify/presentation/home/cubit/news_songs_cubit.dart';

import 'news_songs_cubit_test.mocks.dart';

@GenerateMocks([GetNewsSongsUseCase])
void main() {
  late NewsSongsCubit cubit;
  late MockGetNewsSongsUseCase mockGetNewsSongsUseCase;

  setUp(() {
    mockGetNewsSongsUseCase = MockGetNewsSongsUseCase();
    cubit = NewsSongsCubit(mockGetNewsSongsUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('estado inicial es NewsSongsLoading', () {
    expect(cubit.state, isA<NewsSongsLoading>());
  });

  blocTest<NewsSongsCubit, NewsSongsState>(
    'emite [NewsSongsLoaded] cuando el usecase retorna canciones',
    build: () {
      when(mockGetNewsSongsUseCase.call())
          .thenAnswer((_) async => Right(<SongEntity>[]));
      return cubit;
    },
    act: (cubit) => cubit.getNewsSongs(),
    expect: () => [
      isA<NewsSongsLoaded>(),
    ],
    verify: (_) {
      verify(mockGetNewsSongsUseCase.call()).called(1);
    },
  );

  blocTest<NewsSongsCubit, NewsSongsState>(
    'emite [NewsSongsError] cuando el usecase retorna error',
    build: () {
      when(mockGetNewsSongsUseCase.call())
          .thenAnswer((_) async => Left('error'));
      return cubit;
    },
    act: (cubit) => cubit.getNewsSongs(),
    expect: () => [
      isA<NewsSongsError>(),
    ],
  );
}
