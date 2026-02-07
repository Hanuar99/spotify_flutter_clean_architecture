import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/common/bloc/favorite_button/favorite_button_cubit.dart';
import 'package:spotify/common/widgets/appbar/app_bar_widget.dart';
import 'package:spotify/presentation/home/cubit/news_songs_cubit.dart';
import 'package:spotify/presentation/home/cubit/play_list_cubit.dart';
import 'package:spotify/presentation/home/pages/home_page.dart';
import 'package:spotify/presentation/home/widgets/new_songs_widget.dart';
import 'package:spotify/presentation/home/widgets/play_list_widget.dart';

import '../../../common/bloc/favorite_button/favorite_button_cubit_test.mocks.dart';
import '../cubit/news_songs_cubit_test.mocks.dart';
import '../cubit/play_list_cubit_test.mocks.dart';

void main() {
  late NewsSongsCubit newsSongsCubit;
  late PlayListCubit playListCubit;
  late FavoriteButtonCubit favoriteButtonCubit;
  late MockAddOrRemoveFavoriteUsecase mockAddOrRemoveFavoriteUsecase;

  setUp(() {
    newsSongsCubit = NewsSongsCubit(MockGetNewsSongsUseCase());
    playListCubit = PlayListCubit(MockGetPlayListUseCase());

    newsSongsCubit.emit(NewsSongsLoading());
    playListCubit.emit(PlayListLoading());

    mockAddOrRemoveFavoriteUsecase = MockAddOrRemoveFavoriteUsecase();
    favoriteButtonCubit = FavoriteButtonCubit(mockAddOrRemoveFavoriteUsecase);
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<NewsSongsCubit>.value(value: newsSongsCubit),
          BlocProvider<PlayListCubit>.value(value: playListCubit),
          BlocProvider<FavoriteButtonCubit>.value(value: favoriteButtonCubit),
        ],
        child: HomePage(),
      ),
    );
  }

  testWidgets('HomePage renders correctly', (tester) async {
    await tester.pumpWidget(buildTestableWidget());
    expect(find.byType(HomePage), findsOneWidget);

    expect(find.byType(BasicAppBarWidget), findsOneWidget);
    expect(find.byKey(const Key('logo')), findsOneWidget);

    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    expect(find.byType(TabBar), findsOneWidget);
    expect(find.text('News'), findsOneWidget);
    expect(find.text('Videos'), findsOneWidget);
    expect(find.text('Artists'), findsOneWidget);
    expect(find.text('Podcasts'), findsOneWidget);

    expect(find.byType(TabBarView), findsOneWidget);

    expect(find.byType(NewSongsWidget), findsOneWidget);
    expect(find.byType(PlayListWidget), findsOneWidget);
  });

// testear tab
  testWidgets('HomePage tab', (tester) async {
    await tester.pumpWidget(buildTestableWidget());

    final tabBar = find.byType(TabBar);
    expect(tabBar, findsOneWidget);

    await tester.tap(find.text('Videos'));
    await tester.pump();

    // Verificamos que el TabController cambió
    final TabBar tabBarWidget = tester.widget(tabBar);
    expect(tabBarWidget.controller!.index, 1);
  });

  //navegacion ProfilePage test
  testWidgets('HomePage navigate to ProfilePage', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => MultiBlocProvider(
            providers: [
              BlocProvider<NewsSongsCubit>.value(value: newsSongsCubit),
              BlocProvider<PlayListCubit>.value(value: playListCubit),
              BlocProvider<FavoriteButtonCubit>.value(
                  value: favoriteButtonCubit),
            ],
            child: const HomePage(),
          ),
        ),
        GoRoute(
          path: '/profile',
          builder: (_, __) => const Scaffold(
            body: Text('ProfilePage'),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );

    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    expect(find.text('ProfilePage'), findsOneWidget);
  });
}
