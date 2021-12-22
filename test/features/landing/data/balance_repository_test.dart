import 'dart:convert';

import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/landing/data/datasources/balance_remote_datasource.dart';
import 'package:polkadex/features/landing/data/repositories/balance_repository.dart';

class _MockBalanceRemoteDatasource extends Mock
    implements BalanceRemoteDatasource {}

void main() {
  late _MockBalanceRemoteDatasource dataSource;
  late BalanceRepository repository;
  late String address;
  late String signature;

  setUp(() {
    dataSource = _MockBalanceRemoteDatasource();
    repository = BalanceRepository(balanceRemoteDatasource: dataSource);
    address = 'addressTest';
    signature = 'signatureTest';
  });

  group('Balance repository tests ', () {
    test('Must return a fetch balance response', () async {
      when(() => dataSource.fetchBalance(any(), any())).thenAnswer(
        (_) async => Response(
            jsonEncode({
              "Fine": {
                "free": {"BTC": 0.1},
                "used": {"BTC": 0.1},
                "total": {"BTC": 0.2}
              }
            }),
            200),
      );

      final result = await repository.fetchBalance(
        address,
        signature,
      );

      expect(result.isRight(), true);
      verify(() => dataSource.fetchBalance(address, signature)).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return a failed fetch balance response', () async {
      when(() => dataSource.fetchBalance(any(), any())).thenAnswer(
        (_) async => Response('', 400),
      );

      final result = await repository.fetchBalance(
        address,
        signature,
      );

      expect(result.isLeft(), true);
      verify(() => dataSource.fetchBalance(address, signature)).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}
