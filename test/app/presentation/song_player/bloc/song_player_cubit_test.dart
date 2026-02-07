import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/domain/usecases/usecases.dart';
import 'package:spotify/presentation/song_player/bloc/cubit/song_player_cubit.dart';

import 'song_player_cubit_test.mocks.dart';

@GenerateMocks([
  LoadSongUseCase,
  PlayOrPauseSongUseCase,
  IsSongPlayingUseCase,
  GetSongPositionStreamUseCase,
  GetSongDurationStreamUseCase
])
void main() {
  late MockLoadSongUseCase loadSongUseCase;
  late MockPlayOrPauseSongUseCase playOrPauseSongUseCase;
  late MockIsSongPlayingUseCase isSongPlayingUseCase;
  late MockGetSongPositionStreamUseCase positionStreamUseCase;
  late MockGetSongDurationStreamUseCase durationStreamUseCase;

  late StreamController<Duration> positionController;
  late StreamController<Duration?> durationController;

  setUp(() {
    loadSongUseCase = MockLoadSongUseCase();
    playOrPauseSongUseCase = MockPlayOrPauseSongUseCase();
    isSongPlayingUseCase = MockIsSongPlayingUseCase();
    positionStreamUseCase = MockGetSongPositionStreamUseCase();
    durationStreamUseCase = MockGetSongDurationStreamUseCase();

    positionController = StreamController<Duration>.broadcast();
    durationController = StreamController<Duration?>.broadcast();

    when(positionStreamUseCase()).thenAnswer((_) => positionController.stream);
    when(durationStreamUseCase()).thenAnswer((_) => durationController.stream);
    when(isSongPlayingUseCase()).thenReturn(false);
  });

  tearDown(() async {
    await positionController.close();
    await durationController.close();
  });

  blocTest<SongPlayerCubit, SongPlayerState>(
    'emite SongPlayerLoading como estado inicial',
    build: () => SongPlayerCubit(
      loadSongUseCase: loadSongUseCase,
      playOrPauseSongUseCase: playOrPauseSongUseCase,
      isSongPlayingUseCase: isSongPlayingUseCase,
      positionStreamUseCase: positionStreamUseCase,
      durationStreamUseCase: durationStreamUseCase,
    ),
    expect: () => [],
  );

  blocTest<SongPlayerCubit, SongPlayerState>(
    'loadSong emite SongPlayerLoaded cuando el usecase es exitoso',
    build: () {
      when(loadSongUseCase(any)).thenAnswer((_) async => Right(null));
      return SongPlayerCubit(
        loadSongUseCase: loadSongUseCase,
        playOrPauseSongUseCase: playOrPauseSongUseCase,
        isSongPlayingUseCase: isSongPlayingUseCase,
        positionStreamUseCase: positionStreamUseCase,
        durationStreamUseCase: durationStreamUseCase,
      );
    },
    act: (cubit) => cubit.loadSong('audio-url'),
    expect: () => [
      isA<SongPlayerLoaded>(),
    ],
  );

  blocTest<SongPlayerCubit, SongPlayerState>(
    'loadSong emite SongPlayerError cuando falla',
    build: () {
      when(loadSongUseCase(any)).thenThrow(Exception());
      return SongPlayerCubit(
        loadSongUseCase: loadSongUseCase,
        playOrPauseSongUseCase: playOrPauseSongUseCase,
        isSongPlayingUseCase: isSongPlayingUseCase,
        positionStreamUseCase: positionStreamUseCase,
        durationStreamUseCase: durationStreamUseCase,
      );
    },
    act: (cubit) => cubit.loadSong('audio-url'),
    expect: () => [
      isA<SongPlayerError>(),
    ],
  );

  blocTest<SongPlayerCubit, SongPlayerState>(
    'playOrPause emite SongPlayerLoaded',
    build: () {
      when(playOrPauseSongUseCase()).thenAnswer((_) async => Right(null));
      return SongPlayerCubit(
        loadSongUseCase: loadSongUseCase,
        playOrPauseSongUseCase: playOrPauseSongUseCase,
        isSongPlayingUseCase: isSongPlayingUseCase,
        positionStreamUseCase: positionStreamUseCase,
        durationStreamUseCase: durationStreamUseCase,
      );
    },
    act: (cubit) => cubit.playOrPause(),
    expect: () => [
      isA<SongPlayerLoaded>(),
    ],
  );

  blocTest<SongPlayerCubit, SongPlayerState>(
    'emite SongPlayerLoaded cuando cambia posición o duración',
    build: () {
      return SongPlayerCubit(
        loadSongUseCase: loadSongUseCase,
        playOrPauseSongUseCase: playOrPauseSongUseCase,
        isSongPlayingUseCase: isSongPlayingUseCase,
        positionStreamUseCase: positionStreamUseCase,
        durationStreamUseCase: durationStreamUseCase,
      );
    },
    act: (cubit) async {
      positionController.add(const Duration(seconds: 10));
      durationController.add(const Duration(minutes: 3));
    },
    expect: () => [
      isA<SongPlayerLoaded>(),
      isA<SongPlayerLoaded>(),
    ],
  );

  test('close cancela las subscripciones sin error', () async {
    final cubit = SongPlayerCubit(
      loadSongUseCase: loadSongUseCase,
      playOrPauseSongUseCase: playOrPauseSongUseCase,
      isSongPlayingUseCase: isSongPlayingUseCase,
      positionStreamUseCase: positionStreamUseCase,
      durationStreamUseCase: durationStreamUseCase,
    );

    await cubit.close();

    expect(cubit.isClosed, true);
  });
}
