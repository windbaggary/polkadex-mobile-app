import 'package:polkadex/common/graph/domain/entities/line_chart_entity.dart';

class LineChartModel extends LineChartEntity {
  LineChartModel({
    required DateTime date,
    required double pointY,
  }) : super(
          date: date,
          pointY: pointY,
        );

  factory LineChartModel.fromJsonLow(Map<String, dynamic> map) {
    return LineChartModel(
      date: DateTime.parse(map['_time']),
      pointY: map['low'],
    );
  }

  factory LineChartModel.fromJsonHigh(Map<String, dynamic> map) {
    return LineChartModel(
      date: DateTime.parse(map['_time']),
      pointY: map['high'],
    );
  }

  factory LineChartModel.fromJsonAverage(Map<String, dynamic> map) {
    return LineChartModel(
      date: DateTime.parse(map['_time']),
      pointY: (map['low'] + map['high']) / 2,
    );
  }
}
