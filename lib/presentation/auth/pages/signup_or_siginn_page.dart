import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/common/widgets/appbar/app_bar_widget.dart';
import 'package:spotify/common/widgets/button/basic_app_button_widget.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/generated/assets.gen.dart';

class SignupOrSiginnPage extends StatelessWidget {
  const SignupOrSiginnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BasicAppBarWidget(),
          Align(
            alignment: Alignment.topRight,
            child: Assets.vectors.topPattern.svg(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Assets.vectors.bottomPattern.svg(),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Assets.images.authBg.image(),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Assets.vectors.spotifyLogo.svg(),
                  SizedBox(height: 55),
                  const Text(
                    'Enjoy listening to music',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 21),
                  const Text(
                    'Spotify is a proprietary Swedish audio streaming and media services provider',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: BasicAppButtonWidget(
                            title: 'Register',
                            onPressed: () {
                              context.push(AppRoutes.signin);
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                            onPressed: () {
                              context.push(AppRoutes.signin);
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
