import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';

class TickerModel extends TickerEntity {
  const TickerModel({
    required DateTime timestamp,
    required String high,
    required String low,
    required String last,
    required String previousClose,
    required String average,
  }) : super(
          timestamp: timestamp,
          high: high,
          low: low,
          last: last,
          previousClose: previousClose,
          average: average,
        );

  factory TickerModel.fromJson(Map<String, dynamic> map) {
    return TickerModel(
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] * 1000),
      high: map['high'],
      low: map['low'],
      last: map['last'],
      previousClose: map['previous_close'],
      average: map['average'],
    );
  }
}
