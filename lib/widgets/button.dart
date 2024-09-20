import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String text;
  final Color backgroundColor;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;

  const CustomElevatedButton({
    Key? key,
    required this.isLoading,
    required this.onPressed,
    required this.text,
    this.backgroundColor = const Color.fromARGB(255, 49, 121, 46),
    this.elevation = 10,
    this.padding =
        const EdgeInsets.only(top: 12, bottom: 12, left: 40, right: 40),
    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        padding: padding,
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }
}
