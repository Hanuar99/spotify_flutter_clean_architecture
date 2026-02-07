import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/common/widgets/button/basic_app_button_widget.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/core/router/app_routes.dart';
import 'package:spotify/generated/assets.gen.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Assets.images.introBg.image().image,
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
                  'Enjoy listening to music',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 21),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sagittis enim purus sed phasellus. Cursus ornare id scelerisque aliquam.',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                BasicAppButtonWidget(
                    onPressed: () => context.go(AppRoutes.chooseMode),
                    title: 'Get Started'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
