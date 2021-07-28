import 'package:polkadex/features/setup/domain/entities/encoding_entity.dart';

class ImportedAccountEntity {
  const ImportedAccountEntity({
    required this.pubKey,
    required this.mnemonic,
    required this.rawSeed,
    required this.encoded,
    required this.encoding,
    required this.address,
  });

  final String pubKey;
  final String mnemonic;
  final String rawSeed;
  final String encoded;
  final EncondingEntity encoding;
  final String address;
}
