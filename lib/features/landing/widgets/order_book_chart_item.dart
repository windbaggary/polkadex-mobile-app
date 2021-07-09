import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// The direction for the gradient
enum EnumGradientDirection {
  Left,
  Right,
}

/// The widget for the order book
/// The widget displays the background chart
class OrderBookChartItemWidget extends StatelessWidget {
  final Widget child;
  final double percentage;
  final EnumGradientDirection direction;
  final Color color;

  OrderBookChartItemWidget({
    @required this.child,
    this.percentage = 0.0,
    this.direction,
    this.color = const Color(0xFF0CA564),
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: child,
      painter: _ThisCustomPainter(direction, percentage, color),
    );
  }
}

class _ThisCustomPainter extends CustomPainter {
  final EnumGradientDirection direction;
  final double progress;
  final Color color;

  _ThisCustomPainter(
    this.direction,
    this.progress,
    this.color,
  ) : super();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    final double borderHeight = 1;

    double offsetX = size.width - size.width * this.progress;
    double width = size.width - offsetX;
    List<double> stops = [0.5, 1.0];
    List<Color> colors = <Color>[
      color.withOpacity(0.32),
      color,
    ];

    switch (direction) {
      case EnumGradientDirection.Left:
        offsetX = 0.0;
        width = size.width * this.progress;
        colors = <Color>[
          color,
          color.withOpacity(0.32),
        ];
        stops = [0.3450, 1.0];
        break;
      case EnumGradientDirection.Right:
        offsetX = size.width - size.width * this.progress;
        width = size.width - offsetX;
        colors = <Color>[
          color.withOpacity(0.32),
          color,
        ];
        stops = [0.0, 0.3450];
        break;
    }

    final rect = Rect.fromLTWH(offsetX, 0.0, width, size.height - borderHeight);
    final paintBg = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: colors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: stops,
      ).createShader(rect)
      ..color = Color.fromRGBO(0, 0, 0, 0.2);
    canvas.drawRect(rect, paintBg);

    final rectBorder = Rect.fromLTWH(
      offsetX,
      size.height - borderHeight,
      width,
      borderHeight,
    );
    final paintBorder = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: colors,
        stops: stops,
      ).createShader(rectBorder)
      ..color = Color.fromRGBO(0, 0, 0, 0.60);
    canvas.drawRect(rectBorder, paintBorder);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ThisCustomPainter oldDelegate) {
    return oldDelegate.color != this.color ||
        oldDelegate.direction != this.direction ||
        oldDelegate.progress != this.progress;
  }
}
