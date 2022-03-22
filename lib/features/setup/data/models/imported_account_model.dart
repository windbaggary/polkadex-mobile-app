import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/string_utils.dart';
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
    required bool biometricOnly,
    required bool biometricAccess,
    required String signature,
    required EnumTimerIntervalTypes timerInterval,
  }) : super(
          encoded: encoded,
          encoding: encoding,
          address: address,
          meta: meta,
          name: name,
          biometricOnly: biometricOnly,
          biometricAccess: biometricAccess,
          signature: signature,
          timerInterval: timerInterval,
        );

  factory ImportedAccountModel.fromJson(Map<String, dynamic> map) {
    return ImportedAccountModel(
      encoded: map['encoded'],
      encoding: EncodingModel.fromJson(map['encoding']),
      address: map['address'],
      meta: MetaModel.fromJson(map['meta']),
      name: map['name'] ?? '',
      biometricOnly: map['biometricOnly'] ?? false,
      biometricAccess: map['biometricAccess'] ?? false,
      signature: map['signature'] ?? '',
      timerInterval: StringUtils.enumFromString<EnumTimerIntervalTypes>(
          EnumTimerIntervalTypes.values, map['timerInterval'] ?? 'oneMinute')!,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'encoded': encoded,
      'encoding': (encoding as EncodingModel).toJson(),
      'address': address,
      'meta': (meta as MetaModel).toJson(),
      'name': name,
      'biometricOnly': biometricOnly,
      'biometricAccess': biometricAccess,
      'signature': signature,
      'timerInterval': timerInterval.toString(),
    };
  }

  ImportedAccountModel copyWith({
    String? encoded,
    EncodingEntity? encoding,
    String? address,
    MetaEntity? meta,
    String? name,
    bool? biometricOnly,
    bool? biometricAccess,
    String? signature,
    EnumTimerIntervalTypes? timerInterval,
  }) {
    return ImportedAccountModel(
      encoded: encoded ?? this.encoded,
      encoding: encoding ?? this.encoding,
      address: address ?? this.address,
      meta: meta ?? this.meta,
      name: name ?? this.name,
      biometricOnly: biometricOnly ?? this.biometricOnly,
      biometricAccess: biometricAccess ?? this.biometricAccess,
      signature: signature ?? this.signature,
      timerInterval: timerInterval ?? this.timerInterval,
    );
  }
}
