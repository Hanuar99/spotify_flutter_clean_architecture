import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:spotify/data/repository/auth/auth_repository_impl.dart';
import 'package:spotify/data/repository/song/song_repository_impl.dart';
import 'package:spotify/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify/data/sources/song/song_firebase_service.dart';
import 'package:spotify/domain/repository/auth/auth_repositoy.dart';
import 'package:spotify/domain/repository/song/song_repository.dart';
import 'package:spotify/domain/usecases/auth/get_user_usecase.dart';
import 'package:spotify/domain/usecases/auth/is_user_logged_in_usecase.dart';
import 'package:spotify/domain/usecases/auth/signin_usecase.dart';
import 'package:spotify/domain/usecases/auth/signup_usecase.dart';
import 'package:spotify/domain/usecases/song/add_or_remove_favorite_usecase.dart';
import 'package:spotify/domain/usecases/song/get_favorites_song_usecase.dart';
import 'package:spotify/domain/usecases/song/get_news_songs_usecase.dart';
import 'package:spotify/domain/usecases/song/get_play_list_usecase.dart';
import 'package:spotify/domain/usecases/song/is_favorite_usecase.dart';
import 'package:spotify/presentation/home/cubit/news_songs_cubit.dart';
import 'package:spotify/presentation/home/cubit/play_list_cubit.dart';
import 'package:spotify/presentation/profile/blocs/favorite_songs/favorite_songs_cubit.dart';
import 'package:spotify/presentation/profile/blocs/profile_info_cubit/profile_info_cubit.dart';
import 'package:spotify/service_locator.dart';

void main() {
  final sl = GetIt.instance;

  setUpAll(() async {
    await sl.reset();

    await initializeDependencies(
      firebaseAuth: MockFirebaseAuth(),
      firestore: FakeFirebaseFirestore(),
    );
  });

  tearDownAll(() async {
    await sl.reset();
  });

  group('Service Locator – Dependency Injection', () {
    test('Firebase services are registered', () {
      expect(sl<AuthFirebaseService>(), isA<AuthFirebaseServiceImpl>());
      expect(sl<SongFirebaseService>(), isA<SongFirebaseServiceImpl>());
    });

    test('Repositories are registered', () {
      expect(sl<AuthRepository>(), isA<AuthRepositoryImpl>());
      expect(sl<SongRepository>(), isA<SongRepositoryImpl>());
    });

    test('Use cases are registered', () {
      expect(sl<IsUserLoggedInUseCase>(), isNotNull);
      expect(sl<SigninUseCase>(), isNotNull);
      expect(sl<SignupUseCase>(), isNotNull);
      expect(sl<GetUserUseCase>(), isNotNull);
      expect(sl<GetNewsSongsUseCase>(), isNotNull);
      expect(sl<GetPlayListUseCase>(), isNotNull);
      expect(sl<IsFavoriteUsecase>(), isNotNull);
      expect(sl<AddOrRemoveFavoriteUsecase>(), isNotNull);
      expect(sl<GetFavoritesSongUseCase>(), isNotNull);
    });

    test('Cubits are resolvable', () {
      expect(sl<ProfileInfoCubit>(), isA<ProfileInfoCubit>());
      expect(sl<FavoriteSongsCubit>(), isA<FavoriteSongsCubit>());
      expect(sl<PlayListCubit>(), isA<PlayListCubit>());
      expect(sl<NewsSongsCubit>(), isA<NewsSongsCubit>());
      expect(sl<FavoriteButtonCubit>(), isA<FavoriteButtonCubit>());
    });

    // test('Cubits are factories', () {
    //   final c1 = sl<SplashCubit>();
    //   final c2 = sl<SplashCubit>();

    //   expect(c1, isNot(same(c2)));
    // });

    test('UseCases are singletons', () {
      final u1 = sl<IsUserLoggedInUseCase>();
      final u2 = sl<IsUserLoggedInUseCase>();

      expect(u1, same(u2));
    });
  });
}
