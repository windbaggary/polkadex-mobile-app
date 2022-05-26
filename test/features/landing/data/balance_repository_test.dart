import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:mysql_client/mysql_protocol.dart';
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
      when(() => dataSource.fetchBalance(any())).thenAnswer(
        (_) async => EmptyResultSet(
          okPacket: MySQLPacketOK.decode(
            Uint8List.fromList(
              [
                0x62,
                0x6c,
                0xc3,
                0xa5,
                0x62,
                0xc3,
                0xa6,
                0x72,
                0x67,
                0x72,
                0xc3,
                0xb8,
                0x64
              ],
            ),
          ),
        ),
      );

      final result = await repository.fetchBalance(address);

      expect(result.isRight(), true);
      verify(() => dataSource.fetchBalance(address)).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return a successful test deposit response', () async {
      when(() => dataSource.testDeposit(any(), any(), any())).thenAnswer(
        (_) async => Response(jsonEncode({"Fine": "Ok"}), 200),
      );

      final result = await repository.testDeposit(
        0,
        address,
        signature,
      );

      expect(result.isRight(), true);
      verify(() => dataSource.testDeposit(0, address, signature)).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return a failed test deposit response', () async {
      when(() => dataSource.testDeposit(any(), any(), any())).thenAnswer(
        (_) async => Response(jsonEncode({"Bad": "error"}), 400),
      );

      final result = await repository.testDeposit(
        0,
        address,
        signature,
      );

      expect(result.isLeft(), true);
      verify(() => dataSource.testDeposit(0, address, signature)).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}
