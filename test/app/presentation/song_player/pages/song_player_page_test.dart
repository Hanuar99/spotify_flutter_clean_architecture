import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/presentation/song_player/bloc/cubit/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/pages/song_player_page.dart';

/// ---------------------------------------------------------------------------
/// MOCKS
/// ---------------------------------------------------------------------------

class MockSongPlayerCubit extends MockCubit<SongPlayerState>
    implements SongPlayerCubit {}

class FakeSongPlayerState extends Fake implements SongPlayerState {}

void main() {
  late MockSongPlayerCubit cubit;

  final song = SongEntity(
    songId: '1',
    title: 'Song 1',
    artist: 'Artist 1',
    coverUrl: 'url',
    isFavorite: true,
    duration: 120,
    release: Timestamp.now(),
    audioUrl: 'audio',
  );

  setUpAll(() {
    registerFallbackValue(FakeSongPlayerState());
  });

  setUp(() {
    cubit = MockSongPlayerCubit();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<SongPlayerCubit>.value(
        value: cubit,
        child: SongPlayerPage(song: song),
      ),
    );
  }

  /// ---------------------------------------------------------------------------
  /// TESTS
  /// ---------------------------------------------------------------------------

  testWidgets('muestra loading cuando el estado es SongPlayerLoading',
      (tester) async {
    await mockNetworkImagesFor(() async {
      // arrange
      when(() => cubit.state).thenReturn(SongPlayerLoading());
      whenListen(
        cubit,
        Stream.fromIterable([SongPlayerLoading()]),
        initialState: SongPlayerLoading(),
      );

      // act
      await tester.pumpWidget(makeTestableWidget());

      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  testWidgets('muestra controles cuando el estado es SongPlayerLoaded',
      (tester) async {
    await mockNetworkImagesFor(() async {
      // arrange
      final loadedState = SongPlayerLoaded(
        position: const Duration(seconds: 10),
        duration: const Duration(minutes: 3),
        isPlaying: false,
      );

      when(() => cubit.state).thenReturn(loadedState);
      whenListen(
        cubit,
        Stream.fromIterable([loadedState]),
        initialState: loadedState,
      );

      // act
      await tester.pumpWidget(makeTestableWidget());

      // assert
      expect(find.byKey(const Key('song_slider')), findsOneWidget);
      expect(find.byKey(const Key('play_pause_button')), findsOneWidget);
      expect(find.text('00:00:10'), findsOneWidget);
      expect(find.text('00:03:00'), findsOneWidget);
    });
  });

  testWidgets('tap en play/pause llama playOrPause en el cubit',
      (tester) async {
    await mockNetworkImagesFor(() async {
      // arrange
      final loadedState = SongPlayerLoaded(
        position: const Duration(seconds: 0),
        duration: const Duration(minutes: 2),
        isPlaying: false,
      );

      when(() => cubit.state).thenReturn(loadedState);
      when(() => cubit.playOrPause()).thenAnswer((_) async {});
      whenListen(
        cubit,
        Stream.fromIterable([loadedState]),
        initialState: loadedState,
      );

      await tester.pumpWidget(makeTestableWidget());
      await tester.pumpAndSettle();

      final playPauseButton = find.byKey(const Key('play_pause_button'));

      // 👇 CLAVE: hacer scroll hasta que sea visible
      await tester.ensureVisible(playPauseButton);
      await tester.pumpAndSettle();

      // act
      await tester.tap(playPauseButton);
      await tester.pump();

      // assert
      verify(() => cubit.playOrPause()).called(1);
    });
  });
}
