import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/landing/data/models/fee_model.dart';
import 'package:polkadex/features/landing/domain/entities/fee_entity.dart';

void main() {
  late FeeModel tFee;

  setUp(() {
    tFee = FeeModel(currency: '0', cost: '0');
  });

  test('OrderModel must be a OrderEntity', () {
    expect(tFee, isA<FeeEntity>());
  });
}
