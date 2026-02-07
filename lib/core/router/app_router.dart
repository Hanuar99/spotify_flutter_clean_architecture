import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/core/router/route_guards.dart';
import 'package:spotify/domain/entities/song/song_entity.dart';
import 'package:spotify/presentation/auth/cubits/signin/signin_cubit.dart';
import 'package:spotify/presentation/auth/pages/signin_page.dart';
import 'package:spotify/presentation/auth/pages/signup_or_siginn_page.dart';
import 'package:spotify/presentation/auth/pages/signup_page.dart';
import 'package:spotify/presentation/choose_mode/pages/choose_mode_page.dart';
import 'package:spotify/presentation/home/cubit/news_songs_cubit.dart';
import 'package:spotify/presentation/home/cubit/play_list_cubit.dart';
import 'package:spotify/presentation/home/pages/home_page.dart';
import 'package:spotify/presentation/intro/pages/get_started_page.dart';
import 'package:spotify/presentation/profile/blocs/favorite_songs/favorite_songs_cubit.dart';
import 'package:spotify/presentation/profile/blocs/profile_info_cubit/profile_info_cubit.dart';
import 'package:spotify/presentation/profile/pages/profile_page.dart';
import 'package:spotify/presentation/song_player/bloc/cubit/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/pages/song_player_page.dart';
import 'package:spotify/presentation/splash/pages/splash_page.dart';
import 'package:spotify/service_locator.dart';

class AppRouter {
  final AuthGuard authGuard;

  AppRouter({required this.authGuard});

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashPage(),
        redirect: (context, state) async {
          return authGuard.redirect(state.uri.toString());
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => MultiBlocProvider(providers: [
          BlocProvider(create: (_) => sl<NewsSongsCubit>()..getNewsSongs()),
          BlocProvider(create: (_) => sl<PlayListCubit>()..getPlayList()),
          BlocProvider<FavoriteButtonCubit>(
            create: (_) => sl<FavoriteButtonCubit>(),
          ),
        ], child: const HomePage()),
      ),
      GoRoute(
        path: AppRoutes.getStarted,
        builder: (_, __) => const GetStartedPage(),
      ),
      GoRoute(
        path: AppRoutes.signin,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<SigninCubit>(),
          child: const SigninPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (_, __) => SignupPage(),
      ),
      GoRoute(
        path: AppRoutes.chooseMode,
        builder: (_, __) => const ChooseModePage(),
      ),
      GoRoute(
        path: AppRoutes.signupOrSignin,
        builder: (_, __) => const SignupOrSiginnPage(),
      ),
      GoRoute(
        path: AppRoutes.songPlayer,
        builder: (context, state) {
          final song = state.extra as SongEntity;

          return BlocProvider(
            create: (context) => sl<SongPlayerCubit>()..loadSong(song.audioUrl),
            child: SongPlayerPage(
              song: song,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, __) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<ProfileInfoCubit>()..getUser()),
            BlocProvider(
                create: (_) => sl<FavoriteSongsCubit>()..getFavoriteSongs()),
            BlocProvider<FavoriteButtonCubit>(
              create: (_) => sl<FavoriteButtonCubit>(),
            ),
          ],
          child: const ProfilePage(),
        ),
      ),
    ],
  );
}
