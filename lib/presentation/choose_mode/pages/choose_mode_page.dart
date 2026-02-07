import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/common/widgets/button/basic_app_button_widget.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/generated/assets.gen.dart';
import 'package:spotify/presentation/choose_mode/cubit/theme_cubit.dart';

class ChooseModePage extends StatelessWidget {
  const ChooseModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Assets.images.chooseMode.image().image,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            color: Colors.black.withAlpha(38),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Assets.vectors.spotifyLogo.svg(),
                ),
                Spacer(),
                Text(
                  'Choose mode',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context
                                .read<ThemeCubit>()
                                .updateTheme(ThemeMode.dark);
                          },
                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xff30393C).withAlpha(125),
                                ),
                                child:
                                    Assets.vectors.moon.svg(fit: BoxFit.none),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 40),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context
                                .read<ThemeCubit>()
                                .updateTheme(ThemeMode.light);
                          },
                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xff30393C).withAlpha(125),
                                ),
                                child: Assets.vectors.sun.svg(fit: BoxFit.none),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Light Mode',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 50),
                BasicAppButtonWidget(
                    onPressed: () {
                      context.push(AppRoutes.signupOrSignin);
                    },
                    title: 'Continue'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
