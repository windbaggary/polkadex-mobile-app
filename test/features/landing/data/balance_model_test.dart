import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/landing/data/models/balance_model.dart';
import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';

void main() {
  late BalanceModel tBalance;

  setUp(() {
    tBalance = BalanceModel(
      free: {'BTC': 1.0},
      used: {'BTC': 1.0},
      total: {'BTC': 2.0},
    );
  });

  test('EncodingModel must be a EncodingEntity', () async {
    expect(tBalance, isA<BalanceEntity>());
  });
}
