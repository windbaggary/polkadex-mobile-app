import 'dart:convert';

import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/coin/data/datasources/coin_remote_datasource.dart';
import 'package:polkadex/features/coin/data/repositories/coin_repository.dart';

class _MockCoinRemoteDatasource extends Mock implements CoinRemoteDatasource {}

void main() {
  late _MockCoinRemoteDatasource dataSource;
  late CoinRepository repository;
  late String asset;
  late double amount;
  late String address;
  late String signature;

  setUp(() {
    dataSource = _MockCoinRemoteDatasource();
    repository = CoinRepository(coinRemoteDatasource: dataSource);
    asset = 'PDEX';
    amount = 10.0;
    address = 'addressTest';
    signature = 'signatureTest';
  });

  group('Balance repository tests ', () {
    test('Must return a withdraw response', () async {
      when(() => dataSource.withdraw(any(), any(), any(), any())).thenAnswer(
        (_) async => Response(jsonEncode({"Fine": "Test success"}), 200),
      );

      final result = await repository.withdraw(
        asset,
        amount,
        address,
        signature,
      );

      expect(result.isRight(), true);
      verify(() => dataSource.withdraw(
            asset,
            amount,
            address,
            signature,
          )).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return a failed withdraw response', () async {
      when(() => dataSource.withdraw(any(), any(), any(), any())).thenAnswer(
        (_) async => Response('', 400),
      );

      final result = await repository.withdraw(
        asset,
        amount,
        address,
        signature,
      );

      expect(result.isLeft(), true);
      verify(() => dataSource.withdraw(
            asset,
            amount,
            address,
            signature,
          )).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}
