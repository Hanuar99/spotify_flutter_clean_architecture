import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/domain/usecases/song/get_favorites_song_usecase.dart';
import 'package:spotify/presentation/profile/blocs/favorite_songs/favorite_songs_cubit.dart';

import 'favorite_songs_cubit_test.mocks.dart';

@GenerateMocks([GetFavoritesSongUseCase])
void main() {
  late FavoriteSongsCubit cubit;
  late MockGetFavoritesSongUseCase mockGetFavoritesSongUseCase;

  setUp(() {
    mockGetFavoritesSongUseCase = MockGetFavoritesSongUseCase();
    cubit = FavoriteSongsCubit(mockGetFavoritesSongUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('estado inicial es FavoriteSongsLoading', () {
    expect(cubit.state, isA<FavoriteSongsLoading>());
  });

  blocTest<FavoriteSongsCubit, FavoriteSongsState>(
    'emite [FavoriteSongsLoaded] cuando el usecase retorna canciones',
    build: () {
      when(mockGetFavoritesSongUseCase.call())
          .thenAnswer((_) async => Right(<SongEntity>[]));
      return cubit;
    },
    act: (cubit) => cubit.getFavoriteSongs(),
    expect: () => [
      isA<FavoriteSongsLoaded>(),
    ],
    verify: (_) {
      verify(mockGetFavoritesSongUseCase.call()).called(1);
    },
  );

  blocTest<FavoriteSongsCubit, FavoriteSongsState>(
    'emite [FavoriteSongsError] cuando el usecase falla',
    build: () {
      when(mockGetFavoritesSongUseCase.call())
          .thenAnswer((_) async => Left(Exception('Error')));
      return cubit;
    },
    act: (cubit) => cubit.getFavoriteSongs(),
    expect: () => [
      isA<FavoriteSongsError>(),
    ],
    verify: (_) {
      verify(mockGetFavoritesSongUseCase.call()).called(1);
    },
  );

  blocTest<FavoriteSongsCubit, FavoriteSongsState>(
    'removeSong elimina una canción y emite FavoriteSongsLoaded actualizado',
    build: () => cubit,
    seed: () {
      cubit.favoriteSongs = [
        SongEntity(
          songId: '1',
          title: 'Song 1',
          artist: 'Artist 1',
          coverUrl: 'url',
          isFavorite: true,
          duration: 120,
          release: Timestamp.now(),
          audioUrl: 'audio',
        ),
        SongEntity(
          songId: '2',
          title: 'Song 2',
          artist: 'Artist 2',
          coverUrl: 'url',
          isFavorite: true,
          duration: 130,
          release: Timestamp.now(),
          audioUrl: 'audio',
        ),
      ];
      return FavoriteSongsLoaded(favoriteSongs: cubit.favoriteSongs);
    },
    act: (cubit) => cubit.removeSong(0),
    expect: () => [
      isA<FavoriteSongsLoaded>()
          .having((s) => s.favoriteSongs.length, 'length', 1)
          .having((s) => s.favoriteSongs.first.songId, 'songId', '2'),
    ],
  );

  // //removeSong
  // blocTest<FavoriteSongsCubit, FavoriteSongsState>(
  //   'emite [FavoriteSongsLoaded] cuando se elimina una cancion',
  //   build: () {
  //     when(mockGetFavoritesSongUseCase.call()).thenAnswer((_) async => Right([
  //           SongEntity(
  //             songId: '1',
  //             title: 'Song 1',
  //             artist: 'Artist 1',
  //             coverUrl: 'https://fake.url/image.png',
  //             isFavorite: false,
  //             duration: 120,
  //             release: Timestamp.now(),
  //             audioUrl: 'audio',
  //           ),
  //           SongEntity(
  //             songId: '2',
  //             title: 'Song 1',
  //             artist: 'Artist 1',
  //             coverUrl: 'https://fake.url/image.png',
  //             isFavorite: false,
  //             duration: 120,
  //             release: Timestamp.now(),
  //             audioUrl: 'audio',
  //           ),
  //           SongEntity(
  //             songId: '3',
  //             title: 'Song 1',
  //             artist: 'Artist 1',
  //             coverUrl: 'https://fake.url/image.png',
  //             isFavorite: false,
  //             duration: 120,
  //             release: Timestamp.now(),
  //             audioUrl: 'audio',
  //           ),
  //         ]));
  //     return cubit;
  //   },
  //   act: (cubit) => cubit.removeSong(0),
  //   expect: () => [
  //     isA<FavoriteSongsLoaded>(),
  //   ],
  //   verify: (_) {
  //     verify(mockGetFavoritesSongUseCase.call()).called(1);
  //   },
  // );
}
