import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:polkadex/configs/app_config.dart';
import 'dart:math' as math;

/// The widget to show pie chart
///
/// The data of type [IAppCircleChartModel] must be passed
class AppCircleChartGraphWidget extends ImplicitlyAnimatedWidget {
  /// The child inside the pie chart
  final Widget child;

  /// The height of the chart
  final double height;

  /// The width of the chart
  final double width;

  /// The data to be shown
  final List<IAppCircleChartModel> list;

  /// The total value of pie chart
  final double totalValue;

  /// The stroke width of chart section
  final double strokeWidth;

  /// The stroke width of chart when selected
  final double strokeSelWidth;

  /// The selected index
  final int? selectedIndex;

  const AppCircleChartGraphWidget({
    required this.child,
    required this.list,
    this.totalValue = 100.0,
    this.width = 312,
    this.height = 312,
    this.strokeWidth = 6.0,
    this.strokeSelWidth = 20.0,
    this.selectedIndex,
  }) : super(duration: AppConfigs.animDurationSmall);

  @override
  _AppCircleChartGraphWidgetState createState() =>
      _AppCircleChartGraphWidgetState();
}

class _AppCircleChartGraphWidgetState
    extends AnimatedWidgetBaseState<AppCircleChartGraphWidget> {
  Tween<double>? _indexTween;
  late Tween<double> _strokeTween;

  @override
  void initState() {
    _strokeTween =
        Tween<double>(begin: widget.strokeWidth, end: widget.strokeSelWidth);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.animation;

    return Center(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: CustomPaint(
            painter: _ThisCustomPainter(
              list: widget.list,
              selectedIndex: widget.selectedIndex,
              stroke: widget.strokeWidth,
              strokeSel: widget.strokeSelWidth,
              animationStroke: _strokeTween.evaluate(animation),
            ),
            child: Padding(
                padding: const EdgeInsets.all(36), child: widget.child)),
      ),
    );
  }

  @override
  void forEachTween(visitor) {
    _indexTween = visitor(_indexTween, widget.selectedIndex?.toDouble() ?? -1.0,
        (value) => Tween<double>(begin: value)) as Tween<double>;
  }
}

/// The painted paints the list on the canvas
class _ThisCustomPainter extends CustomPainter {
  final List<IAppCircleChartModel> list;
  final double stroke, strokeSel;
  final int? selectedIndex;
  final double animationStroke;

  _ThisCustomPainter({
    required this.list,
    required this.stroke,
    required this.strokeSel,
    required this.selectedIndex,
    required this.animationStroke,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    final center = Offset(size.width / 2, size.height / 2);
    final double maxStroke = math.max(stroke, strokeSel);
    double colorOpacity = 1.0;

    double totalPercentage = 0.0;
    double selRotateAngle = 0.0;
    if (selectedIndex != null) {
      colorOpacity = 0.5;
    }
    for (int i = 0; i < list.length; i++) {
      canvas.save(
          // Offset.zero & size, Paint()..blendMode = BlendMode.color
          );
      final bool isSelected = i == selectedIndex;
      final iModel = list[i];
      final rotateAngle = math.pi * 2.0 * totalPercentage;

      _rotate(canvas, rotateAngle, center);
      if (isSelected) {
        selRotateAngle = rotateAngle;
      }
      {
        canvas.drawArc(
            Offset(maxStroke / 2, maxStroke / 2) &
                Size(
                  size.width - maxStroke,
                  size.height - maxStroke,
                ),
            math.pi * 1.5,
            math.pi * 2.0 * iModel.iPerc - 0.039,
            false,
            Paint()
              ..color = iModel.iColor.withOpacity(colorOpacity)
              ..style = PaintingStyle.stroke
              // ..blendMode = BlendMode.dstOver
              ..strokeWidth = stroke
              ..strokeCap = StrokeCap.square);
      }
      canvas.restore();
      totalPercentage += iModel.iPerc;
    }

    if (selectedIndex != null) {
      final iModel = list[selectedIndex!];
      canvas.save();
      _rotate(canvas, selRotateAngle, center);
      final Rect rect = Offset(maxStroke / 2, maxStroke / 2) &
          Size(
            size.width - maxStroke,
            size.height - maxStroke,
          );
      final double startAngle = math.pi * 1.5;
      final double sweepAngle = math.pi * 2.0 * iModel.iPerc;

      canvas.drawArc(
        rect.deflate(0),
        startAngle,
        sweepAngle,
        false,
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.black12,
              Colors.black26,
              Colors.black12,
            ],
            stops: [0.87, 99, 1.0],
          ).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = animationStroke * 2.0
          ..strokeCap = StrokeCap.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5),
      );

      canvas.drawArc(
          rect,
          startAngle,
          sweepAngle,
          false,
          Paint()
            ..color = iModel.iColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = animationStroke
            ..strokeCap = StrokeCap.round);

      canvas.restore();
    }

    canvas.restore();
  }

  void _rotate(
    Canvas canvas,
    double angle,
    Offset center,
  ) {
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.translate(-center.dx, -center.dy);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class AppCircleChartModel implements IAppCircleChartModel {
  final double perc;
  final Color color;

  AppCircleChartModel({
    required this.perc,
    required this.color,
  });

  @override
  Color get iColor => color;

  @override
  double get iPerc => perc;
}

abstract class IAppCircleChartModel {
  double get iPerc;
  Color get iColor;
}
