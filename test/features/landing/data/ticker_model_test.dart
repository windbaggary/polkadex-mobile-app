import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/landing/data/models/ticker_model.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';

void main() {
  late TickerModel tTicker;

  setUp(() {
    tTicker = TickerModel(
      timestamp: DateTime.now(),
      high: '0',
      low: '0',
      last: '0',
      previousClose: '0',
      average: '0',
    );
  });

  test('TickerModel must be a TickerEntity', () {
    expect(tTicker, isA<TickerEntity>());
  });
}
