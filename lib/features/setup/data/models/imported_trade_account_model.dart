import 'package:polkadex/features/setup/data/models/encoding_model.dart';
import 'package:polkadex/features/setup/data/models/meta_model.dart';
import 'package:polkadex/features/setup/domain/entities/meta_entity.dart';
import 'package:polkadex/features/setup/domain/entities/encoding_entity.dart';
import 'package:polkadex/features/setup/domain/entities/imported_trade_account_entity.dart';

class ImportedTradeAccountModel extends ImportedTradeAccountEntity {
  const ImportedTradeAccountModel({
    required String address,
    required String encoded,
    required EncodingEntity encoding,
    required MetaEntity meta,
  }) : super(
          address: address,
          encoded: encoded,
          encoding: encoding,
          meta: meta,
        );

  factory ImportedTradeAccountModel.fromJson(Map<String, dynamic> map) {
    return ImportedTradeAccountModel(
      address: map['address'],
      encoded: map['encoded'],
      encoding: EncodingModel.fromJson(map['encoding']),
      meta: MetaModel.fromJson(map['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'address': address,
      'encoded': encoded,
      'encoding': (encoding as EncodingModel).toJson(),
      'meta': (meta as MetaModel).toJson(),
    };
  }
}
