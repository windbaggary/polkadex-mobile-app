import 'package:amplify_api/amplify_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/landing/data/datasources/balance_remote_datasource.dart';
import 'package:polkadex/features/landing/data/repositories/balance_repository.dart';

class _MockBalanceRemoteDatasource extends Mock
    implements BalanceRemoteDatasource {}

class _MockStream extends Mock implements Stream {}

void main() {
  late _MockBalanceRemoteDatasource dataSource;
  late _MockStream stream;
  late BalanceRepository repository;
  late String address;
  late String tDataSuccess;

  setUp(() {
    dataSource = _MockBalanceRemoteDatasource();
    stream = _MockStream();
    repository = BalanceRepository(balanceRemoteDatasource: dataSource);
    address = 'addressTest';
    tDataSuccess = '''{
      "getAllBalancesByMainAccount": {
        "items": [
          {"asset": "PDEX", "free": "100.0", "reversed": "0.0"}
        ],
        "nextToken": null
      }
    }''';
  });

  group('Balance repository tests ', () {
    test('Must return a fetch balance response', () async {
      when(() => dataSource.fetchBalance(any())).thenAnswer(
        (_) async => GraphQLResponse(data: tDataSuccess, errors: []),
      );

      final result = await repository.fetchBalance(address);

      expect(result.isRight(), true);
      verify(() => dataSource.fetchBalance(address)).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return a successful fetch balance live data response', () async {
      when(() => dataSource.fetchBalanceStream(
            any(),
          )).thenAnswer(
        (_) async => stream,
      );

      await repository.fetchBalanceLiveData(
        '',
        (_) {},
        (_) {},
      );

      verify(() => dataSource.fetchBalanceStream('')).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}
