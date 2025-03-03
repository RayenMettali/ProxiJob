import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({super.key});

  @override
  _AnimatedGradientBackgroundState createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..forward()
    ..addListener(() {
      if (controller.value == 1.0) {
        controller.animateTo(0, curve: Curves.easeInOutQuint);
      }
      if (controller.value == 0.0) {
        controller.animateTo(1, curve: Curves.easeInOutCubic);
      }
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final dt = controller.value;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorTween(
                    begin: Colors.orange.withOpacity(0.8),
                    end: const Color.fromARGB(255, 10, 33, 122),
                  ).lerp(dt)!,
                  ColorTween(
                    begin: Colors.orange.withOpacity(0.8),
                    end: const Color.fromARGB(252, 103, 48, 205),
                  ).lerp(dt)!,
                  ColorTween(
                    begin: Colors.orange.withOpacity(0.90),
                    end: const Color.fromARGB(252, 103, 53, 128),
                  ).lerp(dt)!,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
