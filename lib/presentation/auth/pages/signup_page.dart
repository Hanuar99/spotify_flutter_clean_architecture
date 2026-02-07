import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/common/widgets/appbar/app_bar_widget.dart';
import 'package:spotify/common/widgets/button/basic_app_button_widget.dart';
import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/generated/assets.gen.dart';
import 'package:spotify/presentation/auth/cubits/signup/signup_cubit.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is SignupSuccess) {
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
        bottomNavigationBar: _siginText(context),
        appBar: BasicAppBarWidget(
          title: Assets.vectors.spotifyLogo.svg(height: 40, width: 40),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _registerText(),
              const SizedBox(height: 50),
              _fullNameField(),
              const SizedBox(height: 20),
              _emailField(),
              const SizedBox(height: 20),
              _passwordField(),
              const SizedBox(height: 20),
              BasicAppButtonWidget(
                title: 'Create Account',
                onPressed: () {
                  context.read<SignupCubit>().signup(
                        fullName: _fullNameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerText() {
    return Text(
      'Register',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _fullNameField() {
    return TextField(
      controller: _fullNameController,
      decoration: const InputDecoration(
        hintText: 'Full name',
      ),
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

  Widget _siginText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Do you have an account?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              )),
          TextButton(
            onPressed: () {
              context.go(AppRoutes.signin);
            },
            child: const Text('Sign in',
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
