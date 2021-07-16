import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'dart:math' as math;

/// The top slider widget of the home screen
class AppSliderWidget extends StatefulWidget {
  final double height;
  final int itemsDisplayCount;
  final List<Widget> childrens;
  final List<double> offsetsY;
  final List<double> opacities;
  final List<double> scales;

  const AppSliderWidget({
    Key key,
    @required this.childrens,
    this.height,
    this.itemsDisplayCount = 3,
    this.offsetsY,
    this.opacities,
    this.scales,
  }) : super(key: key);
  @override
  _AppSliderWidgetState createState() => _AppSliderWidgetState();
}

class _AppSliderWidgetState extends State<AppSliderWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  int _selectedIndex = 0;
  double _startDx = 0.0;
  double _animPerc = 0.0;
  bool _directionX = true;
  final List<Widget> _contentChildrens = <Widget>[];

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: AppConfigs.animDurationSmall)
          ..addStatusListener(_onStatusListener);
    _updateContentChildrens();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragCancel: () => _onDragComplete(),
      onHorizontalDragEnd: (_) => _onDragComplete(),
      child: SizedBox(
        height: widget.height,
        child: Stack(
          alignment: FractionalOffset.center,
          children: List.generate(
            widget.itemsDisplayCount,
            (index) {
              double bottom;

              Tween<double> scaleTween;
              Tween<double> opacityTween;

              if (widget.offsetsY.length - 1 >= index) {
                bottom = widget.offsetsY[index];
              }

              if (widget.opacities.length - 1 >= index) {
                double begin = widget.opacities[index];
                double end = 1.0;
                if (index != widget.opacities.length - 1) {
                  end = widget.opacities[index + 1];
                }
                // end = widget.opacities[index];
                opacityTween = Tween(begin: begin, end: end);
              }

              if (widget.scales.length - 1 >= index) {
                double begin = widget.scales[index];
                double end = 1.0;
                if (index != widget.scales.length - 1) {
                  end = widget.scales[index + 1];
                }
                // end = widget.scales[index];
                scaleTween = Tween(begin: begin, end: end);
              }

              final Animation<Offset> offsetAnimation = Tween<Offset>(
                begin: Offset(0.0, 0.0),
                end: Offset(400.0, 0.0),
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    0.0,
                    0.75,
                  ),
                ),
              );

              final Animation<double> scaleAnimation = scaleTween.animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.55, 1.0),
                ),
              );
              final Animation<double> opacityAnimation = opacityTween.animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.55, 1.0),
                ),
              );
              final Animation<double> rotateAnimation = Tween<double>(
                begin: 0.0,
                end: math.pi / 3,
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.0, 0.750),
                ),
              );

              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  Offset offset = Offset.zero;
                  double scale = 1.0;
                  double opacity = 1.0;
                  double rotateZ = 0.0;
                  if (index == _selectedIndex) {
                    offset = offsetAnimation.value;
                    rotateZ = rotateAnimation.value;
                  } else {
                    scale = scaleAnimation.value;
                    opacity = opacityAnimation.value;
                  }
                  return Positioned.fill(
                    bottom: bottom,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..scale(scale, scale)
                        ..translate(offset.dx * (this._directionX ? 1.0 : -1.0),
                            offset.dy)
                        ..rotateZ(math.sin(math.pi / 2 * rotateZ) *
                            (this._directionX ? 1.0 : -1.0)),
                      alignment: Alignment.bottomCenter,
                      child: Opacity(
                        opacity: opacity,
                        child: this._contentChildrens[index],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _onStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animationController.reset();
      _directionX = !_directionX;
      _updateContentChildrens();
    }
  }

  void _updateContentChildrens() {
    _selectedIndex = widget.itemsDisplayCount - 1;
    int j = 0;
    this._contentChildrens.clear();
    for (int i = 0; i < widget.itemsDisplayCount; i++) {
      this._contentChildrens.add(widget.childrens[j]);
      j++;
      if (widget.childrens.length <= j) {
        j = 0;
      }
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final dx = details.localPosition.dx;
    final diff = dx - this._startDx;
    this._directionX = !diff.isNegative;
    final renderBox = context.findRenderObject() as RenderBox;
    final perc = (diff / renderBox.size.width).abs().clamp(0.0, 1.0);

    this._animPerc = perc;
    _animationController.value = perc;
  }

  void _onDragStart(DragStartDetails details) {
    _startDx = details.localPosition.dx;
  }

  _onDragComplete() {
    _animationController.forward(from: this._animPerc);
  }
}
