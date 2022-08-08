import 'package:amplify_api/amplify_api.dart';
import 'package:json_rpc_2/json_rpc_2.dart';
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
  late String proxyAddress;
  late String mainAddress;
  late String tWithdrawSuccess;

  setUp(() {
    dataSource = _MockCoinRemoteDatasource();
    repository = CoinRepository(coinRemoteDatasource: dataSource);
    asset = '1';
    amount = 10.0;
    proxyAddress = 'proxyAddressTest';
    mainAddress = 'mainAddressTest';
    tWithdrawSuccess = '''{
      "withdraw": {
        "items": [],
        "nextToken": null
      }
    }''';
  });

  group('Balance repository tests ', () {
    test('Must return a withdraw response', () async {
      when(
        () => dataSource.withdraw(
          any(),
          any(),
          any(),
          any(),
        ),
      ).thenAnswer(
        (_) async => GraphQLResponse(data: tWithdrawSuccess, errors: []),
      );

      final result = await repository.withdraw(
        proxyAddress,
        mainAddress,
        asset,
        amount,
      );

      expect(result.isRight(), true);
      verify(() => dataSource.withdraw(
            proxyAddress,
            mainAddress,
            asset,
            amount,
          )).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return a failed withdraw response', () async {
      when(
        () => dataSource.withdraw(
          any(),
          any(),
          any(),
          any(),
        ),
      ).thenAnswer(
        (_) async => throw RpcException(500, 'error'),
      );

      final result = await repository.withdraw(
        proxyAddress,
        mainAddress,
        asset,
        amount,
      );

      expect(result.isLeft(), true);
      verify(() => dataSource.withdraw(
            proxyAddress,
            mainAddress,
            asset,
            amount,
          )).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}
