import 'package:polkadex/features/coin/domain/entities/fee_entity.dart';

class FeeModel extends FeeEntity {
  const FeeModel({
    required String currency,
    required double cost,
  }) : super(
          currency: currency,
          cost: cost,
        );
}
