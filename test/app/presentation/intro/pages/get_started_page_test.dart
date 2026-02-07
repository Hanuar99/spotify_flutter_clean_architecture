import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/presentation/intro/pages/get_started_page.dart';

void main() {
  testWidgets('GetStartedPage renders and navigates on button tap',
      (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const GetStartedPage(),
        ),
        GoRoute(
          path: '/choose-mode',
          builder: (_, __) => Scaffold(body: Text('ChooseMode')),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );

    // Verifica UI base
    expect(find.text('Enjoy listening to music'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Tap botón
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Navegación ocurrió
    expect(find.text('ChooseMode'), findsOneWidget);
  });
}
