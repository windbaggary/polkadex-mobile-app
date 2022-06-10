import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/string_utils.dart';
import 'package:polkadex/common/orders/domain/entities/order_update_entity.dart';

class OrderUpdateModel extends OrderUpdateEntity {
  const OrderUpdateModel({
    required String orderId,
    required EnumBuySell? orderSide,
    required EnumOrderTypes? orderType,
    required String price,
    required String amount,
    required EnumOrderStatus? status,
  }) : super(
          orderId: orderId,
          orderSide: orderSide,
          orderType: orderType,
          price: price,
          amount: amount,
          status: status,
        );

  factory OrderUpdateModel.fromJson(Map<String, dynamic> map) {
    final update = map['update'] as Map<String, dynamic>;
    final updateKey = update.keys.first;

    return OrderUpdateModel(
      orderId: update[updateKey]['order_id'],
      orderSide: StringUtils.enumFromString<EnumBuySell>(EnumBuySell.values,
          update[updateKey]['side'] == 'Bid' ? 'Buy' : 'Sell'),
      orderType: StringUtils.enumFromString<EnumOrderTypes>(
          EnumOrderTypes.values, update[updateKey]['order_type']),
      price: update[updateKey]['price'],
      amount: update[updateKey]['qty'],
      status: StringUtils.enumFromString<EnumOrderStatus>(
          EnumOrderStatus.values, updateKey),
    );
  }
}
