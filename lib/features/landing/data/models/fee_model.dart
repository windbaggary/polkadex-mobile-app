import 'package:polkadex/features/landing/domain/entities/fee_entity.dart';

class FeeModel extends FeeEntity {
  const FeeModel({
    required String currency,
    required String cost,
  }) : super(
          currency: currency,
          cost: cost,
        );

  factory FeeModel.fromJson(Map<String, dynamic> map) {
    return FeeModel(
      currency: map['currency'].toString(),
      cost: map['cost'],
    );
  }
}
