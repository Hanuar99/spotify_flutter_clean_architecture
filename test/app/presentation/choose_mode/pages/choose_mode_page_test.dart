// choose_mode_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/presentation/choose_mode/cubit/theme_cubit.dart';
import 'package:spotify/presentation/choose_mode/pages/choose_mode_page.dart';

import 'choose_mode_page_test.mocks.dart';

@GenerateMocks([ThemeCubit])
void main() {
  late MockThemeCubit themeCubit;

  setUp(() {
    themeCubit = MockThemeCubit();

    when(themeCubit.state).thenReturn(ThemeMode.system);
    when(themeCubit.stream).thenAnswer(
      (_) => const Stream<ThemeMode>.empty(),
    );
  });

  tearDown(() {
    themeCubit.close();
  });

  testWidgets(
    'ChooseModePage renders and interacts correctly',
    (tester) async {
      final router = GoRouter(
        initialLocation: AppRoutes.chooseMode,
        routes: [
          GoRoute(
            path: AppRoutes.chooseMode,
            builder: (_, __) => BlocProvider<ThemeCubit>.value(
              value: themeCubit,
              child: const ChooseModePage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.signupOrSignin,
            builder: (_, __) => const Scaffold(body: Text('SignupOrSignin')),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      // ---------- Render ----------
      expect(find.text('Choose mode'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Light Mode'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      // ---------- Interacción Theme ----------
      final darkModeGesture = find.byWidgetPredicate(
          (widget) => widget is GestureDetector && widget.child is ClipOval);

      expect(darkModeGesture, findsNWidgets(2));

      await tester.tap(darkModeGesture.at(0));
      verify(themeCubit.updateTheme(ThemeMode.dark)).called(1);

      await tester.tap(darkModeGesture.at(1));
      verify(themeCubit.updateTheme(ThemeMode.light)).called(1);

      // ---------- Navegación ----------
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('SignupOrSignin'), findsOneWidget);
    },
  );
}
