import 'base_chart_entity.dart';

abstract class LineChartEntity extends BaseChartEntity {
  LineChartEntity({
    required this.date,
    required this.pointY,
  });

  /// The date on the X axis
  final DateTime date;
  /// The point on the Y axis
  final double pointY;

  @override
  String toString() {
    return "Date: ${date.toIso8601String()}, Point: $pointY";
  }

  @override
  List<Object> get props => [
    date,
    pointY,
  ];
}
