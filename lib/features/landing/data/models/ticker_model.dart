import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';

class TickerModel extends TickerEntity {
  const TickerModel({
    required String m,
    required double priceChange24Hr,
    required double priceChangePercent24Hr,
    required double open,
    required double close,
    required double high,
    required double low,
    required double volumeBase24hr,
    required double volumeQuote24Hr,
  }) : super(
          m: m,
          priceChange24Hr: priceChange24Hr,
          priceChangePercent24Hr: priceChangePercent24Hr,
          open: open,
          close: close,
          high: high,
          low: low,
          volumeBase24hr: volumeBase24hr,
          volumeQuote24Hr: volumeQuote24Hr,
        );

  factory TickerModel.fromJson(Map<String, dynamic> map) {
    return TickerModel(
      m: map['m'],
      priceChange24Hr: double.parse(map['priceChange24Hr']),
      priceChangePercent24Hr: double.parse(map['priceChangePercent24Hr']),
      open: double.parse(map['open']),
      close: double.parse(map['close']),
      high: double.parse(map['high']),
      low: double.parse(map['low']),
      volumeBase24hr: double.parse(map['volumeBase24hr']),
      volumeQuote24Hr: double.parse(map['volumeQuote24Hr']),
    );
  }
}
