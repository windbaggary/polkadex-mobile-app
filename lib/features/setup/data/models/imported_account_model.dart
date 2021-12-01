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
    required String name,
    required bool biometricAccess,
    required String signature,
  }) : super(
          encoded: encoded,
          encoding: encoding,
          address: address,
          meta: meta,
          name: name,
          biometricAccess: biometricAccess,
          signature: signature,
        );

  factory ImportedAccountModel.fromJson(Map<String, dynamic> map) {
    return ImportedAccountModel(
      encoded: map['encoded'],
      encoding: EncodingModel.fromJson(map['encoding']),
      address: map['address'],
      meta: MetaModel.fromJson(map['meta']),
      name: map['name'] ?? '',
      biometricAccess: map['biometricAccess'] ?? false,
      signature: map['signature'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'encoded': encoded,
      'encoding': (encoding as EncodingModel).toJson(),
      'address': address,
      'meta': (meta as MetaModel).toJson(),
      'name': name,
      'biometricAccess': biometricAccess,
    };
  }

  ImportedAccountModel copyWith({
    String? encoded,
    EncodingEntity? encoding,
    String? address,
    MetaEntity? meta,
    String? name,
    bool? biometricAccess,
    String? signature,
  }) {
    return ImportedAccountModel(
        encoded: encoded ?? this.encoded,
        encoding: encoding ?? this.encoding,
        address: address ?? this.address,
        meta: meta ?? this.meta,
        name: name ?? this.name,
        biometricAccess: biometricAccess ?? this.biometricAccess,
        signature: signature ?? this.signature);
  }
}
