import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polkadex/configs/app_config.dart';

/// The widget that animated to vertical on its init
///
/// Used to List, to make the child animates from [Alignment] width factor
/// The [index] starts from 0 and should not be null
class AppHeightFactorAnimatedWidget extends StatefulWidget {
  final Widget child;
  final int index;
  final AnimationController? animationController;
  final Interval interval;
  const AppHeightFactorAnimatedWidget({
    required this.child,
    required this.index,
    this.animationController,
    this.interval = const Interval(
      0.0,
      1.0,
      curve: Curves.decelerate,
    ),
  });

  @override
  _AppHeightFactorAnimatedWidgetState createState() =>
      _AppHeightFactorAnimatedWidgetState();
}

class _AppHeightFactorAnimatedWidgetState
    extends State<AppHeightFactorAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animaiton;

  @override
  void initState() {
    _animationController = widget.animationController ??
        AnimationController(
          vsync: this,
          duration: AppConfigs.animDurationSmall * 0.5,
          reverseDuration: AppConfigs.animDurationSmall * 0.5,
        );
    _initAnimation();
    Timer(
        Duration(
            milliseconds:
                (widget.index * AppConfigs.animDurationSmall.inMilliseconds) ~/
                    2), () {
      if (widget.animationController == null) {
        _animationController.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if (widget.animationController == null) {
      _disposeAnimationController();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppHeightFactorAnimatedWidget oldWidget) {
    if (oldWidget.animationController != widget.animationController) {
      _animationController = widget.animationController!;
      _initAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animaiton,
      child: widget.child,
      builder: (context, child) => Opacity(
        opacity: _animaiton.value,
        child: Align(
          heightFactor: 1.0 + (0.5 * (1 - _animaiton.value)),
          child: child,
        ),
      ),
    );
  }

  void _disposeAnimationController() {
    _animationController.dispose();
  }

  void _initAnimation() {
    _animaiton =
        CurvedAnimation(parent: _animationController, curve: widget.interval);
  }
}
