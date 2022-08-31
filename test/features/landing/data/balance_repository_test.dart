import 'package:amplify_api/amplify_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/user_data/user_data_remote_datasource.dart';
import 'package:polkadex/features/landing/data/datasources/balance_remote_datasource.dart';
import 'package:polkadex/features/landing/data/repositories/balance_repository.dart';

class _MockBalanceRemoteDatasource extends Mock
    implements BalanceRemoteDatasource {}

class _UserDataRemoteDatasource extends Mock
    implements UserDataRemoteDatasource {}

class _MockStream extends Mock implements Stream {}

void main() {
  late _MockBalanceRemoteDatasource balanceDataSource;
  late _UserDataRemoteDatasource userDataSource;
  late _MockStream stream;
  late BalanceRepository repository;
  late String address;
  late String tDataSuccess;

  setUp(() {
    balanceDataSource = _MockBalanceRemoteDatasource();
    userDataSource = _UserDataRemoteDatasource();
    stream = _MockStream();
    repository = BalanceRepository(
      balanceRemoteDatasource: balanceDataSource,
      userDataRemoteDatasource: userDataSource,
    );
    address = 'addressTest';
    tDataSuccess = '''{
      "getAllBalancesByMainAccount": {
        "items": [
          {"a": "PDEX", "f": "100.0", "r": "0.0"}
        ],
        "nextToken": null
      }
    }''';
  });

  group('Balance repository tests ', () {
    test('Must return a fetch balance response', () async {
      when(() => balanceDataSource.fetchBalance(any())).thenAnswer(
        (_) async => GraphQLResponse(data: tDataSuccess, errors: []),
      );

      final result = await repository.fetchBalance(address);

      expect(result.isRight(), true);
      verify(() => balanceDataSource.fetchBalance(address)).called(1);
      verifyNoMoreInteractions(balanceDataSource);
    });

    test('Must return a successful fetch balance live data response', () async {
      when(() => userDataSource.getUserDataStream(
            any(),
          )).thenAnswer(
        (_) async => stream,
      );

      await repository.fetchBalanceUpdates(
        '',
        (_) {},
        (_) {},
      );

      verify(() => userDataSource.getUserDataStream('')).called(1);
      verifyNoMoreInteractions(userDataSource);
    });
  });
}
