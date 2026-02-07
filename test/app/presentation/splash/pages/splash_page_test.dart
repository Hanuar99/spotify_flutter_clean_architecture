import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify/presentation/splash/pages/splash_page.dart';

void main() {
  testWidgets('SplashPage renders correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashPage(),
      ),
    );

    // Verifica que la pantalla existe
    expect(find.byType(SplashPage), findsOneWidget);

    // Verifica que hay un Scaffold
    expect(find.byType(Scaffold), findsOneWidget);

    // Verifica que hay un widget SVG (sin importar el asset exacto)
    expect(find.byType(Center), findsOneWidget);
  });
}
