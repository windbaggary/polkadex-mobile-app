import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';

class AppLineChartOptions {
  /// The color of line when the a point is selected on the screen
  final Color lineColor;

  /// The background gradient color
  final Gradient areaGradient;

  /// The size of the line when user selected a point
  final double pointerMarkerAxisSize;

  /// The gap between the line when the user selected a point
  final double ponterMarkerAxisGap;

  /// The size of pointer when user selected a point
  final double pointerMarkerSize;

  /// The style of y axis labels
  final TextStyle yLabelTextStyle;

  /// The scale between each points. Decreasing this can make the points close togther
  final double chartScale;

  /// The number of labels to be displayed
  final int yLabelCount;

  /// The padding of top first y axis label. Ratio between 0.0 and 1.0
  final double yAxisTopPaddingRatio;

  /// The prefix alogn with y axis value
  final String? yAxisLabelPrefix;

  /// The bottom padding for the y axis label. Rotio between 0.0 and 1.0
  final double _yAxisBottomPaddingRatio;

  /// Set to true, alignment of selected date will be related to grid bottom
  final bool isGridAlignWithDate;

  final Paint _markerPaint;
  final Paint _markerAxisPaint;
  final Paint _strokePaint;
  final Paint _gridPaint;

  AppLineChartOptions({
    required this.lineColor,
    required this.areaGradient,
    required this.yLabelTextStyle,
    required Color gridColor,
    required double gridStroke,
    required this.chartScale,
    required this.yLabelCount,
    this.isGridAlignWithDate = true,
    this.yAxisTopPaddingRatio = 0.125,
    this.pointerMarkerAxisSize = 1.5,
    this.ponterMarkerAxisGap = 2.5,
    this.pointerMarkerSize = 12.5,
    this.yAxisLabelPrefix,
    double yAxisBottomPaddingRatio = 0.15,
    double lineStroke = 1.5,
    double pointerMarkerStroke = 2,
    Color pointerMarkerColor = Colors.white,
    double pointerMarkerAxisStroke = 1,
    Color pointerMarkerAxisColor = Colors.white54,
  })  : _yAxisBottomPaddingRatio = yAxisBottomPaddingRatio,
        _markerPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = pointerMarkerStroke
          ..color = pointerMarkerColor,
        _markerAxisPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = pointerMarkerAxisStroke
          ..color = pointerMarkerAxisColor,
        _strokePaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = lineColor
          ..strokeWidth = lineStroke,
        _gridPaint = Paint()
          ..color = gridColor
          ..strokeWidth = gridStroke;

  factory AppLineChartOptions.withDefaults({
    double chartScale = 0.004,
    int yLabelCount = 5,
    required Gradient areaGradient,
  }) =>
      AppLineChartOptions(
        chartScale: chartScale,
        lineColor: color8BA1BE.withBlue(180),
        areaGradient: areaGradient,
        gridColor: color8BA1BE.withOpacity(0.15),
        gridStroke: 1,
        yLabelCount: yLabelCount,
        yLabelTextStyle: TextStyle(
          fontSize: 08,
          fontFamily: "WorkSans",
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade400,
        ),
        isGridAlignWithDate: false,
      );

  Paint get markerPaint => _markerPaint;
  Paint get markerAxisPaint => _markerAxisPaint;
  Paint get strokePaint => _strokePaint;
  Paint get gridPaint => _gridPaint;

  double get yAxisBottomPaddingRatio => 1.0 - _yAxisBottomPaddingRatio;
  double get yAxisPaddingRight => 30.0;

  /// This padding is calculated for drawing the background grid,
  /// selection date bottom padding, selection line bottom padding
  double get datePaddingBottom => 30.0;

  double get gridBottomPadding =>
      (isGridAlignWithDate ? datePaddingBottom : 15.0);
}
