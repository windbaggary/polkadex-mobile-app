import 'package:equatable/equatable.dart';
import 'package:polkadex/common/utils/enums.dart';

abstract class OrderbookItemEntity extends Equatable {
  const OrderbookItemEntity({
    required this.id,
    required this.baseAsset,
    required this.quoteAsset,
    required this.orderSide,
    required this.price,
    required this.amount,
    required this.cumulativeAmount,
  });

  final String id;
  final String baseAsset;
  final String quoteAsset;
  final EnumBuySell? orderSide;
  final double price;
  final double amount;
  final double cumulativeAmount;

  @override
  List<Object?> get props => [
        id,
        baseAsset,
        quoteAsset,
        orderSide,
        price,
        amount,
        cumulativeAmount,
      ];
}
