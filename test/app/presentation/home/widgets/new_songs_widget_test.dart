import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/presentation/home/cubit/news_songs_cubit.dart';
import 'package:spotify/presentation/home/widgets/new_songs_widget.dart';

import '../cubit/news_songs_cubit_test.mocks.dart';

void main() {
  late MockGetNewsSongsUseCase mockUseCase;
  late NewsSongsCubit cubit;

  setUp(() {
    mockUseCase = MockGetNewsSongsUseCase();
    cubit = NewsSongsCubit(mockUseCase);
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<NewsSongsCubit>.value(
        value: cubit,
        child: const Scaffold(
          body: NewSongsWidget(),
        ),
      ),
    );
  }

  testWidgets(
    'muestra CircularProgressIndicator mientras carga',
    (tester) async {
      // arrange
      cubit.emit(NewsSongsLoading());

      // act
      await tester.pumpWidget(buildTestableWidget());

      // estado inicial
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'muestra lista de canciones cuando carga correctamente',
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

        cubit.emit(NewsSongsLoaded(newsSongs: songs));

        await tester.pumpWidget(buildTestableWidget());

        await tester.pump();

        expect(find.text('Song 1'), findsOneWidget);
        expect(find.text('Artist 1'), findsOneWidget);
      });
    },
  );

  testWidgets(
    'muestra mensaje de error cuando ocurre un error',
    (tester) async {
      cubit.emit(NewsSongsError(message: 'Error al cargar'));

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.textContaining('Error'), findsOneWidget);
    },
  );

  testWidgets(
    'navega a songPlayer al tocar una canción',
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

        cubit.emit(NewsSongsLoaded(newsSongs: songs));

        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (_, __) => BlocProvider<NewsSongsCubit>.value(
                value: cubit,
                child: const Scaffold(
                  body: NewSongsWidget(),
                ),
              ),
            ),
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
    },
  );
}
