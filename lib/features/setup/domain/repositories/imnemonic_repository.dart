import 'package:dartz/dartz.dart';

abstract class IMnemonicRepository {
  Future<Either<Error, List<String>>> generateMnemonic();
}
