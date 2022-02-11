import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';

class BalanceModel extends BalanceEntity {
  const BalanceModel({
    required Map free,
    required Map used,
    required Map total,
  }) : super(
          free: free,
          used: used,
          total: total,
        );
}
