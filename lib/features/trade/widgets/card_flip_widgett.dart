import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:polkadex/common/configs/app_config.dart';

/// The states to be displayed
enum EnumCardFlipState {
  showFirst,
  showSecond,
}

class CardFlipAnimation extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;
  final EnumCardFlipState cardState;
  final Duration duration;
  const CardFlipAnimation({
    Key key,
    this.cardState = EnumCardFlipState.showSecond,
    @required this.firstChild,
    @required this.secondChild,
    this.duration = AppConfigs.animDurationSmall,
  }) : super(key: key);

  @override
  _CardFlipAnimationState createState() => _CardFlipAnimationState();
}

class _CardFlipAnimationState extends State<CardFlipAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _fronCardAnimation, _backCardAnimation;

  @override
  void didUpdateWidget(covariant CardFlipAnimation oldWidget) {
    switch (widget.cardState) {
      case EnumCardFlipState.showFirst:
        _animationController.reverse().orCancel;
        break;
      case EnumCardFlipState.showSecond:
        _animationController.forward().orCancel;
        break;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _initAnimations();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        Widget child;
        if (_animationController.value <= 0.5) {
          child = Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(math.pi * _fronCardAnimation.value),
            alignment: Alignment.center,
            child: widget.firstChild,
          );
        } else {
          child = Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(math.pi * (-_backCardAnimation.value)),
            alignment: Alignment.center,
            child: widget.secondChild,
          );
        }
        return child;
      },
    );
  }

  void _initAnimations() {
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    _fronCardAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.50),
      ),
    );
    _backCardAnimation = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.50, 1.0),
      ),
    );

    if (widget.cardState == EnumCardFlipState.showSecond) {
      _animationController.forward().orCancel;
    }
  }
}
