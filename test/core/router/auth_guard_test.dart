import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/core/router/route_guards.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockIsUserLoggedInUseCase isUserLoggedIn;
  late AuthGuard authGuard;

  setUp(() {
    isUserLoggedIn = MockIsUserLoggedInUseCase();
    authGuard = AuthGuard(isUserLoggedIn: isUserLoggedIn);
  });

  group('AuthGuard redirect()', () {
    // test('returns null when user is authenticated and route is home', () async {
    //   when(isUserLoggedIn.call()).thenAnswer((_) async => true);

    //   final result = await authGuard.redirect(AppRoutes.home);

    //   expect(result, isNull);
    //   verify(isUserLoggedIn.call()).called(1);
    // });

    test('redirects to home when authenticated and route is getStarted',
        () async {
      when(isUserLoggedIn.call()).thenAnswer((_) async => true);

      final result = await authGuard.redirect(AppRoutes.getStarted);

      expect(result, AppRoutes.home);
    });

    test('redirects to getStarted when unauthenticated and route is home',
        () async {
      when(isUserLoggedIn.call()).thenAnswer((_) async => false);

      final result = await authGuard.redirect(AppRoutes.home);

      expect(result, AppRoutes.getStarted);
    });

    // test('returns null when unauthenticated and route is getStarted', () async {
    //   when(isUserLoggedIn.call()).thenAnswer((_) async => false);

    //   final result = await authGuard.redirect(AppRoutes.getStarted);

    //   expect(result, isNull);
    // });
  });
}
