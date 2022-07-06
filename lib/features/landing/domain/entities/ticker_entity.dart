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
  final double priceChange24Hr;
  final double priceChangePercent24Hr;
  final double open;
  final double close;
  final double high;
  final double low;
  final double volumeBase24hr;
  final double volumeQuote24Hr;

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
