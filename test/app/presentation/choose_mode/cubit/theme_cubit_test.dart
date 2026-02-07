import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:spotify/presentation/choose_mode/cubit/theme_cubit.dart';

void main() {
  group('ThemeCubit', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    late HydratedStorage storage;
    setUpAll(() async {
      final tempDir = await Directory.systemTemp.createTemp();

      storage = await HydratedStorage.build(
        storageDirectory: HydratedStorageDirectory(
          tempDir.path,
        ),
      );

      HydratedBloc.storage = storage;
    });

    tearDownAll(() async {
      await storage.clear();
      await storage.close();
    });

    late ThemeCubit themeCubit;

    setUp(() {
      themeCubit = ThemeCubit();
    });

    tearDown(() {
      themeCubit.close();
    });

    test('initial state should be ThemeMode.system', () {
      expect(themeCubit.state, ThemeMode.system);
    });

    blocTest<ThemeCubit, ThemeMode>(
      'emits ThemeMode.dark when updateTheme is called with dark',
      build: () => themeCubit,
      act: (cubit) => cubit.updateTheme(ThemeMode.dark),
      expect: () => [ThemeMode.dark],
    );
    blocTest<ThemeCubit, ThemeMode>(
      'emits ThemeMode.light when updateTheme is called with light',
      build: () => themeCubit,
      act: (cubit) => cubit.updateTheme(ThemeMode.light),
      expect: () => [ThemeMode.light],
    );

    test('toJson should return correct map', () {
      final json = themeCubit.toJson(ThemeMode.dark);

      expect(json, {'theme': ThemeMode.dark.index});
    });

    test('fromJson should restore ThemeMode correctly', () {
      final restoredTheme =
          themeCubit.fromJson({'theme': ThemeMode.light.index});

      expect(restoredTheme, ThemeMode.light);
    });
  });
}
