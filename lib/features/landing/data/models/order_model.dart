import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required String uuid,
    required EnumBuySell type,
    required String amount,
    required String price,
    required DateTime dateTime,
    required String amountCoin,
    required String priceCoin,
    required EnumOrderTypes orderType,
    required String tokenPairName,
  }) : super(
          uuid: uuid,
          type: type,
          amount: amount,
          price: price,
          dateTime: dateTime,
          amountCoin: amountCoin,
          priceCoin: priceCoin,
          orderType: orderType,
          tokenPairName: tokenPairName,
        );
}
