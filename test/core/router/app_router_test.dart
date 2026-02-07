import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/core/router/app_router.dart';
import 'package:spotify/core/router/route_guards.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockIsUserLoggedInUseCase isUserLoggedIn;
  late AppRouter appRouter;

  setUp(() {
    isUserLoggedIn = MockIsUserLoggedInUseCase();

    when(isUserLoggedIn.call()).thenAnswer((_) async => false);

    appRouter = AppRouter(
      authGuard: AuthGuard(isUserLoggedIn: isUserLoggedIn),
    );
  });
  testWidgets('AppRouter initializes without crashing', (tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: appRouter.router,
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
