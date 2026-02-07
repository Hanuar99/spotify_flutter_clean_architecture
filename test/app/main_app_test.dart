import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:spotify/main_app.dart';
import 'package:spotify/presentation/choose_mode/cubit/theme_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HydratedStorage storage;

  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp();
    storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(dir.path),
    );
    HydratedBloc.storage = storage;
  });

  GoRouter buildTestRouter() {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const SizedBox(),
        ),
      ],
    );
  }

  testWidgets('MainApp uses system theme by default', (tester) async {
    final themeCubit = ThemeCubit();
    addTearDown(themeCubit.close);

    await tester.pumpWidget(
      BlocProvider.value(
        value: themeCubit,
        child: MainApp(
          router: buildTestRouter(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(materialApp.themeMode, ThemeMode.system);
  });

  testWidgets('MainApp switches to dark theme', (tester) async {
    final themeCubit = ThemeCubit();
    addTearDown(themeCubit.close);

    await tester.pumpWidget(
      BlocProvider.value(
        value: themeCubit,
        child: MainApp(
          router: buildTestRouter(),
        ),
      ),
    );

    themeCubit.updateTheme(ThemeMode.dark);
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(materialApp.themeMode, ThemeMode.dark);
  });
}
