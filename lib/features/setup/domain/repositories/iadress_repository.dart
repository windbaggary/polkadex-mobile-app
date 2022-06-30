import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';

abstract class IAdressRepository {
  Future<Either<ApiError, String>> fetchMainAddress(String proxyAdress);
}
