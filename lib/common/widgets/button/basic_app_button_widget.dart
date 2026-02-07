import 'package:flutter/material.dart';

class BasicAppButtonWidget extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final double height;

  const BasicAppButtonWidget({
    super.key,
    required this.onPressed,
    required this.title,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(height),
      ),
      child: Text(title),
    );
  }
}
