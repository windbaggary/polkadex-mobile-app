import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';

class TickerModel extends TickerEntity {
  const TickerModel({
    required String m,
    required num priceChange24Hr,
    required num priceChangePercent24Hr,
    required num open,
    required num close,
    required num high,
    required num low,
    required num volumeBase24hr,
    required num volumeQuote24Hr,
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
      priceChange24Hr: map['pc'],
      priceChangePercent24Hr: map['pcp'],
      open: map['o'],
      close: map['c'],
      high: map['h'],
      low: map['l'],
      volumeBase24hr: map['v_base'],
      volumeQuote24Hr: map['v_quote'],
    );
  }
}
