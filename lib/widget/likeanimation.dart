import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isanimating;
  final Duration duration;
  final VoidCallback? onend;
  final bool? likes;
  LikeAnimation(
      {super.key,
      required this.child,
      this.duration = const Duration(milliseconds: 150),
      required this.isanimating,
      this.onend,
      this.likes = false});

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationcontroller;
  late Animation<double> scale;
  @override
  void initState() {
    super.initState();
    animationcontroller = AnimationController(
      vsync: this,
      //   ~/ 2 ==> divide by half and convert to int
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    );
    scale = Tween<double>(begin: 1, end: 1.5).animate(animationcontroller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isanimating != oldWidget.isanimating) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isanimating || widget.likes!) {
      await animationcontroller.forward();
      await animationcontroller.reverse();
      await Future.delayed(const Duration(milliseconds: 200));
      if (widget.onend != null) {
        widget.onend!();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
