import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/presentation/auth/cubits/signup/signup_cubit.dart';
import 'package:spotify/presentation/auth/pages/signup_page.dart';

class MockSignupCubit extends MockCubit<SignupState> implements SignupCubit {}

void main() {
  late MockSignupCubit mockSignupCubit;
  late GoRouter router;

  setUp(() {
    mockSignupCubit = MockSignupCubit();

    router = GoRouter(
      initialLocation: AppRoutes.signup,
      routes: [
        GoRoute(
          path: AppRoutes.signup,
          builder: (context, state) {
            return BlocProvider<SignupCubit>.value(
              value: mockSignupCubit,
              child: SignupPage(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (_, __) => const Scaffold(
            body: Text('HOME_PAGE'),
          ),
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

  testWidgets('renderiza campos y botón Create Account', (tester) async {
    when(() => mockSignupCubit.state).thenReturn(SignupInitial());

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router),
    );

    expect(find.text('Register'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('llama signup con los valores ingresados', (tester) async {
    when(() => mockSignupCubit.state).thenReturn(SignupInitial());

    when(
      () => mockSignupCubit.signup(
        fullName: any(named: 'fullName'),
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router),
    );

    await tester.enterText(find.byType(TextField).at(0), 'Juan');
    await tester.enterText(find.byType(TextField).at(1), 'juan@mail.com');
    await tester.enterText(find.byType(TextField).at(2), '123456');

    await tester.tap(find.text('Create Account'));
    await tester.pump();

    verify(
      () => mockSignupCubit.signup(
        fullName: 'Juan',
        email: 'juan@mail.com',
        password: '123456',
      ),
    ).called(1);
  });

  testWidgets('muestra SnackBar cuando SignupError', (tester) async {
    whenListen(
      mockSignupCubit,
      Stream.fromIterable([
        SignupInitial(),
        SignupError('Error al registrar'),
      ]),
      initialState: SignupInitial(),
    );

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router),
    );

    await tester.pumpAndSettle(); // escucha el estado

    expect(find.text('Error al registrar'), findsOneWidget);
  });

  testWidgets('navega a Home cuando SignupSuccess', (tester) async {
    whenListen(
      mockSignupCubit,
      Stream.fromIterable([
        SignupInitial(),
        SignupSuccess(),
      ]),
      initialState: SignupInitial(),
    );

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router),
    );

    await tester.pumpAndSettle();

    expect(find.text('HOME_PAGE'), findsOneWidget);
  });

  testWidgets('navega a Signin al presionar Sign in', (tester) async {
    when(() => mockSignupCubit.state).thenReturn(SignupInitial());

    await tester.pumpWidget(
      MaterialApp.router(routerConfig: router),
    );

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('SIGNIN_PAGE'), findsOneWidget);
  });
}
