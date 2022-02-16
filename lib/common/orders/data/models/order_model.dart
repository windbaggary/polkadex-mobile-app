import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/orders/data/models/fee_model.dart';
import 'package:polkadex/common/orders/data/models/trade_model.dart';
import 'package:polkadex/common/orders/domain/entities/order_entity.dart';
import 'package:polkadex/common/orders/domain/entities/fee_entity.dart';
import 'package:polkadex/common/utils/string_utils.dart';
import 'package:polkadex/common/orders/domain/entities/trade_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required String orderId,
    required String mainAcc,
    required String amount,
    required String price,
    required EnumBuySell? orderSide,
    required EnumOrderTypes? orderType,
    required DateTime timestamp,
    required String baseAsset,
    required String quoteAsset,
    required String status,
    required String filledQty,
    required FeeEntity fee,
    required List<TradeEntity> trades,
  }) : super(
          orderId: orderId,
          mainAcc: mainAcc,
          amount: amount,
          price: price,
          orderSide: orderSide,
          orderType: orderType,
          timestamp: timestamp,
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          status: status,
          filledQty: filledQty,
          fee: fee,
          trades: trades,
        );

  factory OrderModel.fromJson(Map<String, dynamic> map) {
    final listTrades = List<TradeEntity>.generate(
      map['trades'].length,
      (index) => TradeModel.fromJson(map['trades'][index]),
    ).toList();

    return OrderModel(
      orderId: map['order_id'],
      mainAcc: map['main_acc'],
      amount: map['amount'],
      price: map['price'],
      orderSide: StringUtils.enumFromString<EnumBuySell>(
          EnumBuySell.values, map['order_side']),
      orderType: StringUtils.enumFromString<EnumOrderTypes>(
          EnumOrderTypes.values, map['order_type']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      baseAsset: map['base_asset'].toString(),
      quoteAsset: map['quote_asset'].toString(),
      status: map['status'],
      filledQty: map['filled_qty'],
      fee: FeeModel.fromJson(map['fee']),
      trades: listTrades,
    );
  }
}
