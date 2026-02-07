import 'package:flutter/material.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';

class FavoriteButtonWidget extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const FavoriteButtonWidget({
    super.key,
    required this.isFavorite,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_outline_outlined,
        color: AppColors.darkGrey,
      ),
    );
  }
}
