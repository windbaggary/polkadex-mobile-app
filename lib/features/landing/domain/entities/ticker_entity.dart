import 'package:equatable/equatable.dart';

abstract class TickerEntity extends Equatable {
  const TickerEntity({
    required this.m,
    required this.priceChange24Hr,
    required this.priceChangePercent24Hr,
    required this.open,
    required this.close,
    required this.high,
    required this.low,
    required this.volumeBase24hr,
    required this.volumeQuote24Hr,
  });

  final String m;
  final num priceChange24Hr;
  final num priceChangePercent24Hr;
  final num open;
  final num close;
  final num high;
  final num low;
  final num volumeBase24hr;
  final num volumeQuote24Hr;

  @override
  List<Object> get props => [
        m,
        priceChange24Hr,
        priceChangePercent24Hr,
        open,
        close,
        high,
        low,
        volumeBase24hr,
        volumeQuote24Hr,
      ];
}
