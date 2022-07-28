import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';

abstract class ICoinRepository {
  Future<Either<ApiError, void>> withdraw(
    String mainAddress,
    String proxyAddress,
    String asset,
    double amount,
  );
}
