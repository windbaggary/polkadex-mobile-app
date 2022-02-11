import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/domain/repositories/imnemonic_repository.dart';

class GenerateMnemonicUseCase {
  GenerateMnemonicUseCase({
    required IMnemonicRepository mnemonicRepository,
  }) : _mnemonicRepository = mnemonicRepository;

  final IMnemonicRepository _mnemonicRepository;

  Future<Either<ApiError, List<String>>> call() async {
    return await _mnemonicRepository.generateMnemonic();
  }
}
