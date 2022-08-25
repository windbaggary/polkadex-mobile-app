import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/data/datasources/address_remote_datasource.dart';
import 'package:polkadex/features/setup/domain/repositories/iadress_repository.dart';

class AddressRepository implements IAdressRepository {
  AddressRepository({required AddressRemoteDatasource addressRemoteDatasource})
      : _addressRemoteDatasource = addressRemoteDatasource;

  final AddressRemoteDatasource _addressRemoteDatasource;

  @override
  Future<Either<ApiError, String>> fetchMainAddress(String proxyAddress) async {
    try {
      final result =
          await _addressRemoteDatasource.fetchMainAddress(proxyAddress);
      String item =
          jsonDecode(result.data)['findUserByProxyAccount']['items'][0];
      item = item.substring(1, item.length - 1);

      final adresses = item.split(',');
      final mainAddress =
          adresses.firstWhere((adress) => adress.contains('range_key'));

      return Right(mainAddress.split('=')[1]);
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error on fetch main account.'));
    }
  }
}
