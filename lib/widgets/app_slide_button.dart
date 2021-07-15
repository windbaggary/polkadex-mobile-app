import 'package:flutter/material.dart';
import 'package:polkadex/configs/app_config.dart';
import 'package:polkadex/utils/styles.dart';

/// The slide button showing on login and withdrawal screen
///
/// The button slides from left to right by changing the text opacity
class AppSlideButton extends StatefulWidget {
  final Widget icon;
  final String? label;
  final EdgeInsets padding;
  final BoxDecoration? decoration;
  final double height;
  final double iconRightSize;
  final VoidCallback? onComplete;

  AppSlideButton({
    required this.icon,
    required this.height,
    this.onComplete,
    this.iconRightSize = 45,
    this.label,
    this.padding = const EdgeInsets.only(
      left: 11,
      top: 8,
      bottom: 8,
      right: 11,
    ),
    this.decoration,
  });

  @override
  _AppSlideButtonState createState() => _AppSlideButtonState();
}

class _AppSlideButtonState extends State<AppSlideButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDurationSmall,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _completeAnim() {
    try {
      if (_animController.isAnimating) _animController.stop();
      if (_animController.value > 0.750) {
        _animController.forward(from: _animController.value).then((value) {
          if (widget.onComplete != null) {
            widget.onComplete!();
          }
          _animController.reverse();
        });
      } else {
        _animController.reverse(from: _animController.value);
      }
    } catch (ex) {
      print(ex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: this.widget.decoration,
      height: widget.height,
      padding: widget.padding,
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Positioned(
              left: widget.iconRightSize,
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) => Opacity(
                    opacity: (1.0 - _animController.value).clamp(0.0, 1.0),
                    child: child,
                  ),
                  child: Text(
                    this.widget.label ?? "",
                    style: tsS16W500CFF,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                final val = _animController.value;
                return Positioned(
                  left: (constraints.maxWidth.clamp(
                          0.0, constraints.maxWidth - widget.iconRightSize)) *
                      val,
                  right: 0.0,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: widget.icon,
                  ),
                );
              },
            ),
            Positioned.fill(
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  final double val =
                      (constraints.biggest.width - details.localPosition.dx)
                              .clamp(0.0, constraints.biggest.width) /
                          (constraints.biggest.width);
                  _animController.value = 1.0 - val;
                },
                onHorizontalDragCancel: () {
                  _completeAnim();
                },
                onHorizontalDragEnd: (details) {
                  _completeAnim();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
