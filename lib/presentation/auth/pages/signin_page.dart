import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/common/widgets/appbar/app_bar_widget.dart';
import 'package:spotify/common/widgets/button/basic_app_button_widget.dart';
import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/presentation/auth/cubits/signin/signin_cubit.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SigninCubit, SigninState>(
      listener: (context, state) {
        if (state is SigninError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is SigninSuccess) {
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
        bottomNavigationBar: _signupText(context),
        appBar: BasicAppBarWidget(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            children: [
              _registerText(),
              const SizedBox(height: 50),
              _emailField(),
              const SizedBox(height: 20),
              _passwordField(),
              const SizedBox(height: 20),
              BlocBuilder<SigninCubit, SigninState>(
                builder: (context, state) {
                  if (state is SigninLoading) {
                    return const CircularProgressIndicator();
                  }
                  return BasicAppButtonWidget(
                    title: 'Sign in',
                    onPressed: () {
                      context.read<SigninCubit>().signIn(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerText() {
    return Text(
      'Sign in',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _emailController,
      decoration: const InputDecoration(
        hintText: 'Enter email',
      ),
    );
  }

  Widget _passwordField() {
    return TextField(
      controller: _passwordController,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
    );
  }

  Widget _signupText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Not a Member?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              )),
          TextButton(
            onPressed: () => context.go(AppRoutes.signup),
            child: const Text('Register',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff288CE9),
                )),
          ),
        ],
      ),
    );
  }
}
