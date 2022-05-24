import 'package:equatable/equatable.dart';

abstract class MarketEntity extends Equatable {
  const MarketEntity({
    required this.assetId,
    required this.baseAsset,
    required this.quoteAsset,
    required this.minimumTradeAmount,
    required this.maximumTradeAmount,
    required this.minimumWithdrawalAmount,
    required this.minimumDepositAmount,
    required this.maximumWithdrawalAmount,
    required this.maximumDepositAmount,
    required this.baseWithdrawalFee,
    required this.quoteWithdrawalFee,
    required this.enclaveId,
  });

  final String assetId;
  final Map<String, dynamic> baseAsset;
  final Map<String, dynamic> quoteAsset;
  final double minimumTradeAmount;
  final double maximumTradeAmount;
  final double minimumWithdrawalAmount;
  final double minimumDepositAmount;
  final double maximumWithdrawalAmount;
  final double maximumDepositAmount;
  final double baseWithdrawalFee;
  final double quoteWithdrawalFee;
  final String enclaveId;

  @override
  List<Object> get props => [
        assetId,
        baseAsset,
        quoteAsset,
        minimumTradeAmount,
        maximumTradeAmount,
        minimumWithdrawalAmount,
        minimumDepositAmount,
        maximumWithdrawalAmount,
        maximumDepositAmount,
        baseWithdrawalFee,
        quoteWithdrawalFee,
        enclaveId,
      ];
}
