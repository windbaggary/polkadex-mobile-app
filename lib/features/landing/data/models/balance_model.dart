import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';

class BalanceModel extends BalanceEntity {
  const BalanceModel({
    required Map free,
    required Map reserved,
  }) : super(
          free: free,
          reserved: reserved,
        );
}
