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
    final result =
        await _addressRemoteDatasource.fetchMainAddress(proxyAddress);

    try {
      String item = result.data?['findUserByProxyAccount']['items'][0];
      item = item.substring(1, item.length - 1);

      final addresses = item.split(',');

      return Right(addresses[1].split('=')[1]);
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error on fetch main account.'));
    }
  }
}
