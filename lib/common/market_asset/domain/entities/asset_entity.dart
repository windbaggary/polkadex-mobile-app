import 'package:equatable/equatable.dart';

abstract class AssetEntity extends Equatable {
  const AssetEntity({
    required this.assetId,
    required this.deposit,
    required this.name,
    required this.symbol,
    required this.decimals,
    required this.isFrozen,
  });

  final String assetId;
  final String deposit;
  final String name;
  final String symbol;
  final String decimals;
  final bool isFrozen;

  @override
  List<Object> get props => [
        assetId,
        deposit,
        name,
        symbol,
        decimals,
        isFrozen,
      ];
}
