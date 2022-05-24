import 'package:polkadex/common/market_asset/domain/entities/market_entity.dart';

class MarketModel extends MarketEntity {
  const MarketModel({
    required String assetId,
    required Map<String, dynamic> baseAsset,
    required Map<String, dynamic> quoteAsset,
    required int minimumTradeAmount,
    required int maximumTradeAmount,
    required int minimumWithdrawalAmount,
    required int minimumDepositAmount,
    required int maximumWithdrawalAmount,
    required int maximumDepositAmount,
    required int baseWithdrawalFee,
    required int quoteWithdrawalFee,
    required String enclaveId,
  }) : super(
          assetId: assetId,
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          minimumTradeAmount: minimumTradeAmount,
          maximumTradeAmount: maximumTradeAmount,
          minimumWithdrawalAmount: minimumWithdrawalAmount,
          minimumDepositAmount: minimumDepositAmount,
          maximumWithdrawalAmount: maximumWithdrawalAmount,
          maximumDepositAmount: maximumDepositAmount,
          baseWithdrawalFee: baseWithdrawalFee,
          quoteWithdrawalFee: quoteWithdrawalFee,
          enclaveId: enclaveId,
        );

  factory MarketModel.fromJson(Map<String, dynamic> map) {
    return MarketModel(
      assetId: map['assetId'],
      baseAsset: map['baseAsset'],
      quoteAsset: map['quoteAsset'],
      minimumTradeAmount: map['minimumTradeAmount'],
      maximumTradeAmount: map['maximumTradeAmount'],
      minimumWithdrawalAmount: map['minimumWithdrawalAmount'],
      minimumDepositAmount: map['minimumDepositAmount'],
      maximumWithdrawalAmount: map['maximumWithdrawalAmount'],
      maximumDepositAmount: map['maximumDepositAmount'],
      baseWithdrawalFee: map['baseWithdrawalFee'],
      quoteWithdrawalFee: map['quoteWithdrawalFee'],
      enclaveId: map['enclaveId'],
    );
  }
}
