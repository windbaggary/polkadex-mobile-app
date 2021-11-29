import 'package:polkadex/common/graph/domain/entities/line_chart_entity.dart';

class LineChartModel extends LineChartEntity {
  LineChartModel({
    required DateTime date,
    required double pointY,
  }) : super(
          date: date,
          pointY: pointY,
        );

  factory LineChartModel.fromJson(Map<String, dynamic> map) {
    return LineChartModel(
      date: DateTime.parse(map['_time']),
      pointY: map['open'],
    );
  }
}
