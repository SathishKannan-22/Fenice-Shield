import 'package:flutter/material.dart';

class PositionedBackButton extends StatelessWidget {
  final double top;
  final double left;
  final Color iconColor;
  final double iconSize;
  final VoidCallback? onPressed;

  const PositionedBackButton({
    Key? key,
    this.top = 20.0,
    this.left = 20.0,
    this.iconColor = Colors.grey,
    this.iconSize = 42.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: IconButton(
        onPressed: onPressed ??
            () {
              Navigator.pop(context);
            },
        icon: Icon(
          Icons.arrow_back_rounded,
          color: iconColor,
          size: iconSize,
        ),
      ),
    );
  }
}
