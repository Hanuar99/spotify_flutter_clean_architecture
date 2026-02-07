import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/presentation/auth/pages/signup_or_siginn_page.dart';

void main() {
  late GoRouter router;

  setUp(() {
    router = GoRouter(
      initialLocation: AppRoutes.signupOrSignin,
      routes: [
        GoRoute(
          path: AppRoutes.signupOrSignin,
          builder: (_, __) => const SignupOrSiginnPage(),
        ),
        GoRoute(
          path: AppRoutes.signin,
          builder: (_, __) => const Scaffold(
            body: Text('SIGNIN_PAGE'),
          ),
        ),
      ],
    );
  });

  Widget buildWidget() {
    return MaterialApp.router(
      routerConfig: router,
    );
  }

  group('SignupOrSigninPage UI', () {
    testWidgets(
      'renders main title, description and action buttons',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        expect(find.text('Enjoy listening to music'), findsOneWidget);
        expect(
          find.textContaining('Spotify is a proprietary'),
          findsOneWidget,
        );

        expect(find.text('Register'), findsOneWidget);
        expect(find.text('Sign in'), findsOneWidget);
      },
    );
  });

  group('SignupOrSigninPage Navigation', () {
    testWidgets(
      'navigates to Signin when Register button is pressed',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        expect(find.text('SIGNIN_PAGE'), findsOneWidget);
      },
    );

    testWidgets(
      'navigates to Signin when Sign in button is pressed',
      (tester) async {
        await tester.pumpWidget(buildWidget());

        await tester.tap(find.text('Sign in'));
        await tester.pumpAndSettle();

        expect(find.text('SIGNIN_PAGE'), findsOneWidget);
      },
    );
  });
}
