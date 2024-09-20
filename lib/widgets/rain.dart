import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RainAnimation extends StatelessWidget {
  const RainAnimation({super.key});

  List<Widget> _buildRainImages() {
    List<Widget> rainImages = [];
    for (double topOffset = -250; topOffset <= 80; topOffset += 100) {
      for (double leftOffset = -250; leftOffset <= 300; leftOffset += 100) {
        rainImages.add(
          Positioned(
            top: topOffset,
            left: leftOffset,
            child: Lottie.asset(
              'assets/json/rain.json',
              width: 400,
              height: 400,
            ),
          ),
        );
      }
    }
    return rainImages;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _buildRainImages(),
    );
  }
}
