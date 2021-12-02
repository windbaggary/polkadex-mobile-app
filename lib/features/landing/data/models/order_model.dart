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

  factory OrderModel.fromJson(Map<String, dynamic> map) {
    return OrderModel(
      uuid: map['uuid'],
      type: map['type'],
      amount: map['amount'],
      price: map['price'],
      dateTime: map['dateTime'],
      amountCoin: map['amountCoin'],
      priceCoin: map['priceCoin'],
      orderType: map['orderType'],
      tokenPairName: map['tokenPairName'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uuid': uuid,
      'type': type,
      'amount': amount,
      'price': price,
      'dateTime': dateTime,
      'amountCoin': amountCoin,
      'priceCoin': priceCoin,
      'orderType': orderType,
      'tokenPairName': tokenPairName,
    };
  }
}
