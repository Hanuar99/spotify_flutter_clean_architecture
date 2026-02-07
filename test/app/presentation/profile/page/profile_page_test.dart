import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:spotify/common/widgets/favorite_button/favorite_button_widget.dart';
import 'package:spotify/domain/entities/auth/user_entity.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/presentation/profile/blocs/favorite_songs/favorite_songs_cubit.dart';
import 'package:spotify/presentation/profile/blocs/profile_info_cubit/profile_info_cubit.dart';
import 'package:spotify/presentation/profile/pages/profile_page.dart';

import '../../../common/bloc/favorite_button/favorite_button_cubit_test.mocks.dart';
import '../bloc/favorite_songs/favorite_songs_cubit_test.mocks.dart';
import '../bloc/profile_info/profile_info_cubit_test.mocks.dart';

void main() {
  late MockGetUserUseCase mockGetUserUseCase;
  late MockGetFavoritesSongUseCase mockGetFavoritesSongUseCase;
  late ProfileInfoCubit profileInfoCubit;
  late FavoriteSongsCubit favoriteSongsCubit;
  late FavoriteButtonCubit favoriteButtonCubit;
  late MockAddOrRemoveFavoriteUsecase mockAddOrRemoveFavoriteUsecase;

  setUp(() {
    mockGetUserUseCase = MockGetUserUseCase();
    mockGetFavoritesSongUseCase = MockGetFavoritesSongUseCase();
    profileInfoCubit = ProfileInfoCubit(mockGetUserUseCase);
    favoriteSongsCubit = FavoriteSongsCubit(mockGetFavoritesSongUseCase);

    mockAddOrRemoveFavoriteUsecase = MockAddOrRemoveFavoriteUsecase();
    favoriteButtonCubit = FavoriteButtonCubit(mockAddOrRemoveFavoriteUsecase);
  });

  tearDown(() {
    profileInfoCubit.close();
    favoriteSongsCubit.close();
    favoriteButtonCubit.close();
  });

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<FavoriteSongsCubit>.value(value: favoriteSongsCubit),
          BlocProvider<ProfileInfoCubit>.value(value: profileInfoCubit),
          BlocProvider<FavoriteButtonCubit>.value(value: favoriteButtonCubit),
        ],
        child: child,
      ),
    );
  }

  testWidgets(' [ProfileInfo] muestra CircularProgressIndicator mientras carga',
      (tester) async {
    profileInfoCubit.emit(ProfileInfoLoading());

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider(create: (_) => profileInfoCubit, child: ProfileInfo()),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(' [ProfileInfo] muestra informacion perfil', (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
        home:
            BlocProvider(create: (_) => profileInfoCubit, child: ProfileInfo()),
      ));

      profileInfoCubit.emit(ProfileInfoLoaded(UserEntity(
        fullName: 'name',
        email: 'email',
        imageUrl: 'imageUrl',
      )));

      await tester.pump();

      expect(find.text('name'), findsOneWidget);
      expect(find.text('email'), findsOneWidget);
    });
  });

  //Error [ProfileInfo]
  testWidgets(' [ProfileInfo] muestra error', (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
        home:
            BlocProvider(create: (_) => profileInfoCubit, child: ProfileInfo()),
      ));

      profileInfoCubit.emit(ProfileInfoError('error'));

      await tester.pump();

      expect(find.text('error'), findsOneWidget);
    });
  });

  testWidgets(
      ' [FavoriteSongs] muestra CircularProgressIndicator mientras carga',
      (tester) async {
    favoriteSongsCubit.emit(FavoriteSongsLoading());

    await tester.pumpWidget(MaterialApp(
        home: MultiBlocProvider(
      providers: [
        BlocProvider<FavoriteSongsCubit>.value(value: favoriteSongsCubit),
        BlocProvider<FavoriteButtonCubit>.value(value: favoriteButtonCubit),
      ],
      child: FavoriteSongs(),
    )));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(' [FavoriteSongs] muestra informacion perfil', (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
        providers: [
          BlocProvider<FavoriteSongsCubit>.value(value: favoriteSongsCubit),
          BlocProvider<FavoriteButtonCubit>.value(value: favoriteButtonCubit),
        ],
        child: FavoriteSongs(),
      )));

      favoriteSongsCubit.emit(FavoriteSongsLoaded(favoriteSongs: [
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
      ]));

      await tester.pump();

      expect(find.text('Song 1'), findsOneWidget);
      expect(find.text('Artist 1'), findsOneWidget);
    });
  });

  //Error [FavoriteSongs]
  testWidgets(' [FavoriteSongs] muestra error', (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(MaterialApp(
          home: MultiBlocProvider(
        providers: [
          BlocProvider<FavoriteSongsCubit>.value(value: favoriteSongsCubit),
          BlocProvider<FavoriteButtonCubit>.value(value: favoriteButtonCubit),
        ],
        child: FavoriteSongs(),
      )));

      favoriteSongsCubit.emit(FavoriteSongsError());

      await tester.pump();

      expect(find.text('Please try again'), findsOneWidget);
    });
  });

  //hacer test para cuando se hace ontap FavoriteButtonWidget remove song
  testWidgets('[FavoriteSongs] eliminar cancion favorita', (tester) async {
    await mockNetworkImagesFor(() async {
      when(mockAddOrRemoveFavoriteUsecase.call(any))
          .thenAnswer((_) async => Right(false));

      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<FavoriteSongsCubit>.value(
                value: favoriteSongsCubit,
              ),
              BlocProvider<FavoriteButtonCubit>.value(
                value: favoriteButtonCubit,
              ),
            ],
            child: FavoriteSongs(),
          ),
        ),
      );

      favoriteSongsCubit.emit(
        FavoriteSongsLoaded(
          favoriteSongs: [
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

      await tester.pump();

      expect(find.text('Song 1'), findsOneWidget);
      expect(find.text('Artist 1'), findsOneWidget);

      await tester.tap(find.byType(FavoriteButtonWidget));
      await tester.pumpAndSettle();

      expect(find.text('Song 1'), findsNothing);
      expect(find.text('Artist 1'), findsNothing);
    });
  });
}
