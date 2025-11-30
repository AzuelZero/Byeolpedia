import 'package:flutter/material.dart';

class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int duration;
  final Curve curve;

  CustomPageRoute({
    required this.child,
    this.duration = 300,
    this.curve = Curves.easeInOut,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: Duration(milliseconds: duration),
          reverseTransitionDuration: Duration(milliseconds: duration),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );
          },
        );
}