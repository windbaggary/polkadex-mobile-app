import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';

abstract class IBalanceRepository {
  Future<Either<ApiError, BalanceEntity>> fetchBalance(
    String address,
    String signature,
  );
}
