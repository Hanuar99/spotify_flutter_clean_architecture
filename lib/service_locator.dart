import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:spotify/core/router/app_router.dart';
import 'package:spotify/core/router/route_guards.dart';
import 'package:spotify/data/repository/audio/audio_player_repositoy_impl.dart';
import 'package:spotify/data/repository/auth/auth_repository_impl.dart';
import 'package:spotify/data/repository/song/song_repository_impl.dart';
import 'package:spotify/data/sources/audio/audio_player_datasource.dart';
import 'package:spotify/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify/data/sources/song/song_firebase_service.dart';
import 'package:spotify/domain/repository/audio/audio_player_repository.dart';
import 'package:spotify/domain/repository/auth/auth_repositoy.dart';
import 'package:spotify/domain/repository/song/song_repository.dart';
import 'package:spotify/domain/usecases/audio/get_song_duration_stream_usecase.dart';
import 'package:spotify/domain/usecases/audio/get_song_position_stream_usecase.dart';
import 'package:spotify/domain/usecases/audio/is_song_playing_usecase.dart';
import 'package:spotify/domain/usecases/audio/load_song_usecase.dart';
import 'package:spotify/domain/usecases/audio/play_or_pause_song_usecase.dart';
import 'package:spotify/domain/usecases/auth/get_user_usecase.dart';
import 'package:spotify/domain/usecases/auth/is_user_logged_in_usecase.dart';
import 'package:spotify/domain/usecases/auth/signin_usecase.dart';
import 'package:spotify/domain/usecases/auth/signup_usecase.dart';
import 'package:spotify/domain/usecases/song/add_or_remove_favorite_usecase.dart';
import 'package:spotify/domain/usecases/song/get_favorites_song_usecase.dart';
import 'package:spotify/domain/usecases/song/get_news_songs_usecase.dart';
import 'package:spotify/domain/usecases/song/get_play_list_usecase.dart';
import 'package:spotify/domain/usecases/song/is_favorite_usecase.dart';
import 'package:spotify/presentation/auth/cubits/signin/signin_cubit.dart';
import 'package:spotify/presentation/home/cubit/news_songs_cubit.dart';
import 'package:spotify/presentation/home/cubit/play_list_cubit.dart';
import 'package:spotify/presentation/profile/blocs/favorite_songs/favorite_songs_cubit.dart';
import 'package:spotify/presentation/profile/blocs/profile_info_cubit/profile_info_cubit.dart';
import 'package:spotify/presentation/song_player/bloc/cubit/song_player_cubit.dart';

final sl = GetIt.instance;
Future<void> initializeDependencies({
  required FirebaseAuth firebaseAuth,
  required FirebaseFirestore firestore,
}) async {
  // External
  sl.registerSingleton<FirebaseAuth>(firebaseAuth);
  sl.registerSingleton<FirebaseFirestore>(firestore);

  // Data sources
  sl.registerSingleton<AuthFirebaseService>(
    AuthFirebaseServiceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  sl.registerSingleton<SongFirebaseService>(
    SongFirebaseServiceImpl(
      auth: sl(),
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton<AudioPlayerDataSource>(
    () => AudioPlayerDataSourceImpl(AudioPlayer()),
  );

  // Repositories
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(authFirebaseService: sl()),
  );

  sl.registerSingleton<SongRepository>(
    SongRepositoryImpl(songFirebaseService: sl()),
  );

  sl.registerLazySingleton<AudioPlayerRepository>(
    () => AudioPlayerRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerSingleton(IsUserLoggedInUseCase(sl()));
  sl.registerSingleton(SignupUseCase(sl()));
  sl.registerSingleton(SigninUseCase(sl()));
  sl.registerSingleton(GetUserUseCase(sl()));
  sl.registerSingleton(GetNewsSongsUseCase(sl()));
  sl.registerSingleton(GetPlayListUseCase(sl()));
  sl.registerSingleton(IsFavoriteUsecase(sl()));
  sl.registerSingleton(AddOrRemoveFavoriteUsecase(sl()));
  sl.registerSingleton(GetFavoritesSongUseCase(sl()));
  sl.registerLazySingleton(() => LoadSongUseCase(sl()));
  sl.registerLazySingleton(() => PlayOrPauseSongUseCase(sl()));
  sl.registerLazySingleton(() => GetSongDurationStreamUseCase(sl()));
  sl.registerLazySingleton(() => GetSongPositionStreamUseCase(sl()));
  sl.registerLazySingleton(() => IsSongPlayingUseCase(sl()));

  // Cubits
  sl.registerFactory(() => ProfileInfoCubit(sl()));
  sl.registerFactory(() => FavoriteSongsCubit(sl()));
  sl.registerFactory(() => PlayListCubit(sl()));
  sl.registerFactory(() => NewsSongsCubit(sl()));
  sl.registerFactory(() => SigninCubit(signinUseCase: sl()));
  sl.registerFactory(() => FavoriteButtonCubit(sl()));
  sl.registerFactory(
    () => SongPlayerCubit(
      loadSongUseCase: sl(),
      playOrPauseSongUseCase: sl(),
      positionStreamUseCase: sl(),
      durationStreamUseCase: sl(),
      isSongPlayingUseCase: sl(),
    ),
  );

  // core/router/auth_guard.dart
  sl.registerLazySingleton<AuthGuard>(
    () => AuthGuard(
      isUserLoggedIn: sl<IsUserLoggedInUseCase>(),
    ),
  );

  sl.registerLazySingleton<AppRouter>(
    () => AppRouter(
      authGuard: sl<AuthGuard>(),
    ),
  );
}
