import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/data/models/fee_model.dart';
import 'package:polkadex/features/landing/domain/entities/trade_entity.dart';
import 'package:polkadex/features/landing/domain/entities/fee_entity.dart';
import 'package:polkadex/common/utils/string_utils.dart';

class TradeModel extends TradeEntity {
  const TradeModel({
    required String id,
    required DateTime timestamp,
    required String mainAcc,
    required String baseAsset,
    required String quoteAsset,
    required String orderId,
    required EnumOrderTypes? orderType,
    required EnumBuySell? orderSide,
    required String price,
    required String amount,
    required FeeEntity fee,
  }) : super(
          id: id,
          timestamp: timestamp,
          mainAcc: mainAcc,
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          orderId: orderId,
          orderType: orderType,
          orderSide: orderSide,
          price: price,
          amount: amount,
          fee: fee,
        );

  factory TradeModel.fromJson(Map<String, dynamic> map) {
    return TradeModel(
      id: map['id'],
      timestamp: map['timestamp'],
      mainAcc: map['main_acc'],
      baseAsset: map['base_asset'],
      quoteAsset: map['quote_asset'],
      orderId: map['orderId'],
      orderSide: StringUtils.enumFromString<EnumBuySell>(
          EnumBuySell.values, map['base_asset']),
      orderType: StringUtils.enumFromString<EnumOrderTypes>(
          EnumOrderTypes.values, map['order_type']),
      price: map['price'],
      amount: map['amount'],
      fee: FeeModel.fromJson(map['fee']),
    );
  }
}
