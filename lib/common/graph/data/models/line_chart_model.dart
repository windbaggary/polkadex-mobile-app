import 'package:polkadex/common/graph/domain/entities/line_chart_entity.dart';

class LineChartModel extends LineChartEntity {
  LineChartModel({
    required DateTime date,
    required double pointY,
  }) : super(
          date: date,
          pointY: pointY,
  );
}
