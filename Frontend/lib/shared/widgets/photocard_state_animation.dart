import 'package:flutter/material.dart';

class PhotocardStateAnimation extends StatefulWidget {
  final Widget child;
  final bool isOwned;
  final Duration duration;

  const PhotocardStateAnimation({
    super.key,
    required this.child,
    required this.isOwned,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  State<PhotocardStateAnimation> createState() => _PhotocardStateAnimationState();
}

class _PhotocardStateAnimationState extends State<PhotocardStateAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    ));

    if (widget.isOwned) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(PhotocardStateAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOwned != widget.isOwned) {
      if (widget.isOwned) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}