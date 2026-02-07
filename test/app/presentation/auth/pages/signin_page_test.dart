import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spotify/common/widgets/button/basic_app_button_widget.dart';
import 'package:spotify/presentation/auth/cubits/signin/signin_cubit.dart';
import 'package:spotify/presentation/auth/pages/signin_page.dart';

import 'signin_page_test.mocks.dart';

@GenerateMocks([SigninCubit])
void main() {
  provideDummy<SigninState>(SigninInitial());

  late MockSigninCubit mockSigninCubit;
  late GoRouter router;

  setUp(() {
    mockSigninCubit = MockSigninCubit();

    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => BlocProvider<SigninCubit>.value(
            value: mockSigninCubit,
            child: const SigninPage(),
          ),
        ),
        GoRoute(
          path: '/home',
          builder: (_, __) => const Scaffold(
            body: Text('HOME_PAGE'),
          ),
        ),
        GoRoute(
          path: '/signup',
          builder: (_, __) => const Scaffold(
            body: Text('SIGNUP_PAGE'),
          ),
        ),
      ],
    );
  });

  tearDown(() {
    mockSigninCubit.close();
  });

  Widget buildWidget() {
    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('muestra inputs y botón Sign in', (tester) async {
    when(mockSigninCubit.state).thenReturn(SigninInitial());
    when(mockSigninCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(buildWidget());

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(BasicAppButtonWidget), findsOneWidget);

    final button = tester.widget<BasicAppButtonWidget>(
      find.byType(BasicAppButtonWidget),
    );

    expect(button.title, 'Sign in');
  });
  testWidgets('muestra loading cuando el estado es SigninLoading',
      (tester) async {
    when(mockSigninCubit.state).thenReturn(SigninLoading());
    when(mockSigninCubit.stream).thenAnswer(
      (_) => Stream.value(SigninLoading()),
    );

    await tester.pumpWidget(buildWidget());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(BasicAppButtonWidget), findsNothing);
  });
  testWidgets('llama signIn al presionar el botón', (tester) async {
    when(mockSigninCubit.state).thenReturn(SigninInitial());
    when(mockSigninCubit.stream).thenAnswer((_) => const Stream.empty());

    when(
      mockSigninCubit.signIn(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenAnswer((_) async {
      return;
    });

    await tester.pumpWidget(buildWidget());

    await tester.enterText(find.byType(TextField).at(0), 'test@mail.com');
    await tester.enterText(find.byType(TextField).at(1), '123456');

    await tester.tap(find.byType(BasicAppButtonWidget));
    await tester.pump();

    verify(
      mockSigninCubit.signIn(
        email: 'test@mail.com',
        password: '123456',
      ),
    ).called(1);
  });
  testWidgets('muestra SnackBar cuando ocurre un error', (tester) async {
    when(mockSigninCubit.state).thenReturn(SigninInitial());
    when(mockSigninCubit.stream).thenAnswer(
      (_) => Stream.fromIterable([
        SigninInitial(),
        SigninError('Error'),
      ]),
    );

    await tester.pumpWidget(buildWidget());
    await tester.pump();
    await tester.pump();

    expect(find.text('Error'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });
  testWidgets('navega a home cuando el estado es SigninSuccess',
      (tester) async {
    when(mockSigninCubit.state).thenReturn(SigninInitial());
    when(mockSigninCubit.stream).thenAnswer(
      (_) => Stream.fromIterable([
        SigninInitial(),
        SigninSuccess(),
      ]),
    );

    await tester.pumpWidget(buildWidget());
    await tester.pumpAndSettle();

    expect(find.text('HOME_PAGE'), findsOneWidget);
  });
  testWidgets('navega a signup cuando se presiona Register', (tester) async {
    when(mockSigninCubit.state).thenReturn(SigninInitial());
    when(mockSigninCubit.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(buildWidget());

    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.text('SIGNUP_PAGE'), findsOneWidget);
  });
}
