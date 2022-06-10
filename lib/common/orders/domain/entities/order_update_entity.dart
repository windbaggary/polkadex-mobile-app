import 'package:equatable/equatable.dart';
import 'package:polkadex/common/utils/enums.dart';

abstract class OrderUpdateEntity extends Equatable {
  const OrderUpdateEntity({
    required this.orderId,
    required this.orderSide,
    required this.orderType,
    required this.price,
    required this.amount,
    required this.status,
  });

  final String orderId;
  final EnumBuySell? orderSide;
  final EnumOrderTypes? orderType;
  final String price;
  final String amount;
  final EnumOrderStatus? status;

  @override
  List<Object?> get props => [
        orderId,
        orderSide,
        orderType,
        price,
        amount,
        status,
      ];
}
