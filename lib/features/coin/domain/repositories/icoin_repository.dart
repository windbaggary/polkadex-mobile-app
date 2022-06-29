import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';

abstract class ICoinRepository {
  Future<Either<ApiError, String>> withdraw(
    String asset,
    double amount,
    String address,
  );
}
