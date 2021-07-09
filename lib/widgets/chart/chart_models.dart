/// The base model for the chart
///
/// Currently we are having [LineChartModel]
///
/// This model need to be implemented for other chart models
abstract class BaseChartModel {}

/// The model is representation for the line chart for the app
class LineChartModel extends BaseChartModel {
  /// The date on the X axis
  final DateTime date;

  /// The point on the Y axis
  final double pointY;

  LineChartModel(this.date, this.pointY) : super();

  @override
  String toString() {
    return "Date: ${date?.toIso8601String()}, Point: $pointY";
  }
}
