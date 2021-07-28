import 'package:polkadex/features/setup/data/models/encoding_model.dart';
import 'package:polkadex/features/setup/domain/entities/encoding_entity.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';

class ImportedAccountModel extends ImportedAccountEntity {
  const ImportedAccountModel({
    required String pubKey,
    required String mnemonic,
    required String rawSeed,
    required String encoded,
    required EncondingEntity encoding,
    required String address,
  }) : super(
          pubKey: pubKey,
          mnemonic: mnemonic,
          rawSeed: rawSeed,
          encoded: encoded,
          encoding: encoding,
          address: address,
        );

  factory ImportedAccountModel.fromJson(Map<String, dynamic> map) {
    return ImportedAccountModel(
      pubKey: map['pubKey'],
      mnemonic: map['mnemonic'],
      rawSeed: map['rawSeed'],
      encoded: map['encoded'],
      encoding: EncodingModel.fromJson(map['encoding']),
      address: map['address'],
    );
  }
}
