import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '_chart_options.dart';
import 'chart_models.dart';

import 'dart:math' as math;
import '_app_chart_custom_widget.dart';

export '_chart_options.dart';

/// The widget to display the line chart.
///
/// The widget accept data of type [List<LineChartModel>]
/// Use [AppLineChartOptions] to customise the chart colors and all
class AppLineChartWidget extends BaseAppChartCustomWidget<LineChartModel> {
  final AppLineChartOptions options;

  AppLineChartWidget(
      {required List<LineChartModel> data, required this.options})
      : super(parentData: data);

  List<LineChartModel> get data => super.parentData;

  @override
  void iPaintChart(
    Canvas canvas,
    Size size,
    Offset offset,
    Offset? touchPoint,
  ) {
    if (data.isEmpty) {
      return;
    }
    // Declaring a variable to check user has a selection
    int? selectedModelIndex;

    // Finding the total difference of dates to find the ratio of x axis
    final double xDiffInSec =
        data.last.date.difference(data.first.date).inSeconds.toDouble();

    // Cutt the list into those data which the UI is needed.
    // The data upto fill 0 and its previous
    final List<Offset> listDataOffset = <Offset>[];

    for (int i = data.length - 1; i >= 0; i--) {
      double pathX =
          _gexXFromDate(data[i].date, data.first.date, xDiffInSec, size.width);
      listDataOffset.add(Offset(pathX, data[i].pointY));

      // If user has a touch point then set the [selectedModelIndex] to position
      if (touchPoint != null) {
        if ((pathX - touchPoint.dx).abs() < 10.0) {
          selectedModelIndex = i;
        }
      }

      // If the X Axis on device comes to 0.0, then stop on previous element
      if (pathX < 0) {
        if (i > 0) {
          // Adding the previous element of 0.0 X Axis
          pathX = _gexXFromDate(
              data[i - 1].date, data.first.date, xDiffInSec, size.width);
          listDataOffset.add(Offset(pathX, data[i - 1].pointY));
        }
        break;
      }
    }

    // Set the limit to the data needed on UI
    final int xLimit = listDataOffset.length;
    int xOffset = (data.length - xLimit).clamp(0, data.length);
    final List<LineChartModel> currentData =
        data.skip(xOffset).take(xLimit).toList();

    // Calculate the maximum value of y
    final double yMax = _getMaxRoundValue(currentData.reduce((value, element) {
      if (value.pointY > element.pointY) {
        return value;
      } else
        return element;
    }).pointY);
    final double yRatio = size.height / yMax;

    Offset? lineOnPath;

    final Path path = Path();
    final Path strokePath = Path();
    double pathX = listDataOffset.first.dx;
    double pathY = size.height - (listDataOffset.first.dy * yRatio);

    path.moveTo(pathX, size.height);
    strokePath.moveTo(pathX, pathY);
    for (int i = 0; i < listDataOffset.length; i++) {
      pathX = listDataOffset[i].dx;
      pathY = size.height - (listDataOffset[i].dy * yRatio);

      path.lineTo(pathX, pathY);
      strokePath.lineTo(pathX, pathY);

      if (touchPoint != null) {
        if ((pathX - touchPoint.dx).abs() < 10.0) {
          lineOnPath = Offset(pathX, pathY);
        }
      }
    }
    canvas.drawPath(strokePath, options.strokePaint);

    path.lineTo(pathX, size.height);
    path.close();

    canvas.drawPath(
        path,
        Paint()
          ..shader = options.areaGradient
              .createShader(Rect.fromLTWH(0.0, 0.0, size.width, size.height)));

    if (lineOnPath != null && selectedModelIndex != null) {
      // Creating the textpainter for the selected model so the grid line
      // can be make on top
      String date = intl.DateFormat("yyyy/MM/dd HH:mm")
          .format(data[selectedModelIndex].date);
      final tp = _createDatePainter(date);

      drawPointerMarkerAxis(
        canvas,
        lineOnPath,
        Size(
          size.width,
          size.height - (tp.height),
        ),
      );
      drawPointerMarker(canvas, lineOnPath);

      drawSelectedText(canvas, tp, size);
    }

    drawYAxisLabels(canvas, offset, size, yMax);
  }

  /// Calculate the X axis point on the screen
  double _gexXFromDate(
    DateTime dateTime,
    DateTime firstDate,
    double xDiffInSec,
    double screenWidth,
  ) {
    double value =
        (dateTime.difference(firstDate).inSeconds.toDouble() - xDiffInSec) *
            options.chartScale;
    value = (value) + (screenWidth * 1.0);
    return value;
  }

  /// Calculate the maximum value and add 1/4th to it
  double _getMaxRoundValue(double value) {
    double val =
        math.pow(10, value.truncate().abs().toString().length - 1).toDouble();

    val = (value / val).ceilToDouble() * val;
    val += val / 4;
    return val;
  }

  void drawPointerMarkerAxis(
    Canvas canvas,
    Offset offset,
    Size size,
  ) {
    // Draw X
    double start = 0.0;
    while (start < size.width) {
      canvas.drawLine(
        Offset(start, offset.dy),
        Offset(start + options.pointerMarkerAxisSize, offset.dy),
        options.markerAxisPaint,
      );
      start += options.ponterMarkerAxisGap + options.pointerMarkerAxisSize;
    }
    start = 0.0;

    while (start < size.height) {
      canvas.drawLine(
        Offset(offset.dx, start),
        Offset(offset.dx, start + options.pointerMarkerAxisSize),
        options.markerAxisPaint,
      );
      start += options.ponterMarkerAxisGap + options.pointerMarkerAxisSize;
    }
  }

  void drawPointerMarker(Canvas canvas, Offset offset) {
    final double lineHalf = options.pointerMarkerSize * 0.5;
    canvas.drawLine(Offset(offset.dx - lineHalf, offset.dy),
        Offset(offset.dx + lineHalf, offset.dy), options.markerPaint);
    canvas.drawLine(Offset(offset.dx, offset.dy - lineHalf),
        Offset(offset.dx, offset.dy + lineHalf), options.markerPaint);
  }

  @override
  void iPaintGrid(Canvas canvas, Size size, Offset offset) {
    final int gridCount = 8;
    final double widthGap = size.width / gridCount;
    double start = 0;
    while (start < size.width) {
      canvas.drawLine(
          Offset(start + widthGap, 0),
          Offset(start + widthGap, size.height - options.gridBottomPadding),
          options.gridPaint);
      start += widthGap;
    }
  }

  void drawSelectedText(Canvas canvas, TextPainter tp, Size size) {
    Offset textOffset = Offset((size.width - tp.width) * 0.5,
        size.height - tp.height - options.datePaddingBottom * 0.5);
    tp.paint(canvas, textOffset);
  }

  TextPainter _createDatePainter(String date) {
    TextSpan ts = TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: "DATE ",
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'WorkSans',
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        TextSpan(
          text: "$date",
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'WorkSans',
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
    TextPainter tp = TextPainter(
      text: ts,
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
    );
    tp.layout();

    return tp;
  }

  void drawYAxisLabels(Canvas canvas, Offset offset, Size size, double yMax) {
    final List<_AxisLabelModel> yAxises = <_AxisLabelModel>[];

    if (options.yLabelCount > 0) {
      yAxises.add(_AxisLabelModel(
          ratioDy: options.yAxisBottomPaddingRatio,
          labelValue: yMax * (1.0 - options.yAxisBottomPaddingRatio)));
    }

    if (options.yLabelCount > 2) {
      final int count = options.yLabelCount - 1;

      final double contentRatio =
          options.yAxisBottomPaddingRatio - options.yAxisTopPaddingRatio;
      final double singleContentRatio = contentRatio / count;

      for (int i = count; i >= 1; i--) {
        final double ratio =
            (options.yAxisTopPaddingRatio + (singleContentRatio * i));
        yAxises.add(
            _AxisLabelModel(ratioDy: ratio, labelValue: (1.0 - ratio) * yMax));
      }
    }
    if (options.yLabelCount > 1)
      yAxises.add(_AxisLabelModel(
          ratioDy: options.yAxisTopPaddingRatio,
          labelValue: yMax * (1.0 - options.yAxisTopPaddingRatio)));

    // Draw with text painter
    for (int i = 0; i < yAxises.length; i++) {
      final TextSpan ts = TextSpan(
        text:
            "${options.yAxisLabelPrefix ?? ""}${yAxises[i].labelValue.toStringAsFixed(1)}",
        style: options.yLabelTextStyle,
      );
      final TextPainter tp = TextPainter(
          text: ts,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr)
        ..layout();
      final double x = size.width - tp.width - options.yAxisPaddingRight;
      final double y =
          ((size.height * yAxises[i].ratioDy) - (tp.height * 0.5)).clamp(
        0.0 + (tp.height * 1.0),
        size.height - (tp.height * 1.0),
      );

      tp.paint(canvas, Offset(x, y));
    }
  }
}

class _AxisLabelModel {
  final double ratioDy;
  final double labelValue;

  const _AxisLabelModel({required this.ratioDy, required this.labelValue});
}
