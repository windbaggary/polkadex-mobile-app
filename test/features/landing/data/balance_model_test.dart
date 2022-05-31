import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/landing/data/models/balance_model.dart';
import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';

void main() {
  late BalanceModel tBalance;

  setUp(() {
    tBalance = BalanceModel(
      free: {'BTC': 1.0},
      reserved: {'BTC': 1.0},
    );
  });

  test('EncodingModel must be a EncodingEntity', () async {
    expect(tBalance, isA<BalanceEntity>());
  });
}
