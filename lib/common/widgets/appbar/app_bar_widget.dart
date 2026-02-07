import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';

class BasicAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;
  final Color? backgroundColor;
  final bool hideBack;
  const BasicAppBarWidget({
    super.key,
    this.title,
    this.hideBack = false,
    this.action,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: !hideBack,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      title: title,
      actions: [action ?? Container()],
      centerTitle: true,
      leading: hideBack
          ? null
          : IconButton(
              icon: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? Colors.white.withAlpha(7)
                      : Colors.black.withAlpha(7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 15,
                ),
              ),
              onPressed: () => context.pop(),
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
