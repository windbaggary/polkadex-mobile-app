import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/setup/data/datasources/address_remote_datasource.dart';
import 'package:polkadex/features/setup/data/repositories/address_repository.dart';

class _MockAddressRemoteDatasource extends Mock
    implements AddressRemoteDatasource {}

void main() {
  late _MockAddressRemoteDatasource dataSource;
  late AddressRepository repository;
  late String tProxyAddress;
  late String tMainAddress;
  late Map<String, dynamic> tDataSuccess;
  late Map<String, dynamic> tDataError;

  setUp(() {
    dataSource = _MockAddressRemoteDatasource();
    repository = AddressRepository(addressRemoteDatasource: dataSource);
    tProxyAddress = "k9o1dxJxQE8Zwm5Fy";
    tMainAddress = "abcdefg123456789";
    tDataSuccess = {
      "findUserByProxyAccount": {
        "items": [
          '{main_account=proxy-abcdefg123456789, item_type=abcdefg123456789}'
        ],
        "nextToken": null
      },
    };
    tDataError = {
      "findUserByProxyAccount": {"items": [], "nextToken": null},
    };
  });

  group('Address repository tests ', () {
    test('Must return the main address related to the proxy address', () async {
      when(() => dataSource.fetchMainAddress(any())).thenAnswer(
        (_) async => QueryResult.optimistic(
          options: QueryOptions(
            document: gql(''), // this is the query string you just created
          ),
          data: tDataSuccess,
        ),
      );

      final result = await repository.fetchMainAddress(tProxyAddress);
      String resultMainAddress = '';

      result.fold(
        (_) {},
        (mainAddress) => resultMainAddress = mainAddress,
      );

      expect(resultMainAddress, tMainAddress);
      verify(() => dataSource.fetchMainAddress(tProxyAddress)).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test(
        'Must return error related to the main address fetching using proxy address',
        () async {
      when(() => dataSource.fetchMainAddress(any())).thenAnswer(
        (_) async => QueryResult.optimistic(
          options: QueryOptions(
            document: gql(''), // this is the query string you just created
          ),
          data: tDataError,
        ),
      );

      final result = await repository.fetchMainAddress(tProxyAddress);

      expect(result.isLeft(), true);
      verify(() => dataSource.fetchMainAddress(tProxyAddress)).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}
