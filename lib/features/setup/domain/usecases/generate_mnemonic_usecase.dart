import 'package:dartz/dartz.dart';
import 'package:polkadex/features/setup/data/repositories/mnemonic_repository.dart';

class GenerateMnemonicUseCase {
  GenerateMnemonicUseCase({
    required MnemonicRepository mnemonicRepository,
  }) : _mnemonicRepository = mnemonicRepository;

  final MnemonicRepository _mnemonicRepository;

  Future<Either<Error, List<String>>> call() async {
    return await _mnemonicRepository.generateMnemonic();
  }
}
