import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:spotify/common/widgets/favorite_button/favorite_button_widget.dart';
import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/presentation/home/cubit/play_list_cubit.dart';
import 'package:spotify/presentation/home/widgets/play_list_widget.dart';

import '../../../common/bloc/favorite_button/favorite_button_cubit_test.mocks.dart';
import '../cubit/play_list_cubit_test.mocks.dart';

void main() {
  late MockGetPlayListUseCase mockGetPlayListUseCase;
  late PlayListCubit playListCubit;

  late FavoriteButtonCubit favoriteButtonCubit;
  late MockAddOrRemoveFavoriteUsecase mockAddOrRemoveFavoriteUsecase;

  setUp(() {
    mockGetPlayListUseCase = MockGetPlayListUseCase();
    playListCubit = PlayListCubit(mockGetPlayListUseCase);

    mockAddOrRemoveFavoriteUsecase = MockAddOrRemoveFavoriteUsecase();
    favoriteButtonCubit = FavoriteButtonCubit(mockAddOrRemoveFavoriteUsecase);
  });

  Widget makeTestableWidget() {
    return MaterialApp(
        home: MultiBlocProvider(providers: [
      BlocProvider<PlayListCubit>.value(value: playListCubit),
      BlocProvider<FavoriteButtonCubit>.value(value: favoriteButtonCubit),
    ], child: PlayListWidget()));
  }

  testWidgets(
    'muestra CircularProgressIndicator mientras carga',
    (tester) async {
      // arrange
      playListCubit.emit(PlayListLoading());
      // act
      await tester.pumpWidget(makeTestableWidget());
      // assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'muestra ListView con PlayListLoaded',
    (tester) async {
      await mockNetworkImagesFor(() async {
        final songs = [
          SongEntity(
            songId: '1',
            title: 'Song 1',
            artist: 'Artist 1',
            coverUrl: 'https://fake.url/image.png',
            isFavorite: false,
            duration: 120,
            release: Timestamp.now(),
            audioUrl: 'audio',
          ),
        ];

        playListCubit.emit(PlayListLoaded(playList: songs));
        await tester.pumpWidget(makeTestableWidget());
        await tester.pump();

        expect(find.text('PlayList'), findsOneWidget);
        expect(find.text('See More'), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
        expect(find.text('Song 1'), findsOneWidget);
        expect(find.text('Artist 1'), findsOneWidget);
        expect(find.byType(FavoriteButtonWidget), findsOneWidget);
      });
    },
  );

  testWidgets(
    'muestra Text con PlayListError',
    (tester) async {
      // arrange
      playListCubit.emit(PlayListError(message: 'Error message'));
      // act
      await tester.pumpWidget(makeTestableWidget());
      // assert
      expect(find.text('Error message'), findsOneWidget);
    },
  );

  testWidgets('navega a SongPlayerPage cuando se presiona un item',
      (tester) async {
    await mockNetworkImagesFor(() async {
      final song = SongEntity(
        songId: '1',
        title: 'Song 1',
        artist: 'Artist 1',
        coverUrl: 'https://fake.url/image.png',
        isFavorite: false,
        duration: 120,
        release: Timestamp.now(),
        audioUrl: 'audio',
      );
      playListCubit.emit(PlayListLoaded(playList: [song]));
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
              path: '/',
              builder: (_, __) => MultiBlocProvider(
                    providers: [
                      BlocProvider<PlayListCubit>.value(value: playListCubit),
                      BlocProvider<FavoriteButtonCubit>.value(
                          value: favoriteButtonCubit),
                    ],
                    child: const Scaffold(
                      body: PlayListWidget(),
                    ),
                  )),
          GoRoute(
            path: AppRoutes.songPlayer,
            builder: (_, state) => const SizedBox(
              key: Key('song-player-page'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      await tester.pump();

      // act
      await tester.tap(find.text('Song 1'));
      await tester.pumpAndSettle();

      // assert
      expect(find.byKey(const Key('song-player-page')), findsOneWidget);
    });
  });

  testWidgets('[PlayList] marcar/desmarcar favorito', (tester) async {
    await mockNetworkImagesFor(() async {
      when(mockAddOrRemoveFavoriteUsecase.call(any))
          .thenAnswer((_) async => Right(false));

      playListCubit.emit(
        PlayListLoaded(
          playList: [
            SongEntity(
              songId: '1',
              title: 'Song 1',
              artist: 'Artist 1',
              coverUrl: 'https://fake.url/image.png',
              isFavorite: true,
              duration: 120,
              release: Timestamp.now(),
              audioUrl: 'audio',
            ),
          ],
        ),
      );

      await tester.pumpWidget(makeTestableWidget());
      await tester.pump();

      await tester.tap(find.byType(FavoriteButtonWidget));
      await tester.pumpAndSettle();

      verify(mockAddOrRemoveFavoriteUsecase.call('1')).called(1);
    });
  });

  tearDown(() {
    playListCubit.close();
  });
}
