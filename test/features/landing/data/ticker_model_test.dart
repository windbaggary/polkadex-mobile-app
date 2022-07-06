import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/landing/data/models/ticker_model.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';

void main() {
  late TickerModel tTicker;

  setUp(() {
    tTicker = TickerModel(
      m: 'PDEX-1',
      priceChange24Hr: 1.0,
      priceChangePercent24Hr: 1.0,
      open: 1.0,
      close: 1.0,
      high: 1.0,
      low: 1.0,
      volumeBase24hr: 1.0,
      volumeQuote24Hr: 1.0,
    );
  });

  test('TickerModel must be a TickerEntity', () {
    expect(tTicker, isA<TickerEntity>());
  });
}
