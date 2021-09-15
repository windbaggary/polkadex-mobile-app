import 'package:polkadex/features/setup/data/models/encoding_model.dart';
import 'package:polkadex/features/setup/data/models/meta_model.dart';
import 'package:polkadex/features/setup/domain/entities/encoding_entity.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/entities/meta_entity.dart';

class ImportedAccountModel extends ImportedAccountEntity {
  const ImportedAccountModel({
    required String encoded,
    required EncodingEntity encoding,
    required String address,
    required MetaEntity meta,
  }) : super(
          encoded: encoded,
          encoding: encoding,
          address: address,
          meta: meta,
        );

  factory ImportedAccountModel.fromJson(Map<String, dynamic> map) {
    return ImportedAccountModel(
      encoded: map['encoded'],
      encoding: EncodingModel.fromJson(map['encoding']),
      address: map['address'],
      meta: MetaModel.fromJson(map['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'encoded': encoded,
      'encoding': (encoding as EncodingModel).toJson(),
      'address': address,
      'meta': (meta as MetaModel).toJson(),
    };
  }
}
