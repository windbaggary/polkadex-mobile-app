import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/string_utils.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';

class ImportedAccountModel extends ImportedAccountEntity {
  const ImportedAccountModel({
    required String mainAddress,
    required String proxyAddress,
    required String name,
    required bool biometricAccess,
    required EnumTimerIntervalTypes timerInterval,
  }) : super(
          mainAddress: mainAddress,
          proxyAddress: proxyAddress,
          name: name,
          biometricAccess: biometricAccess,
          timerInterval: timerInterval,
        );

  factory ImportedAccountModel.fromJson(Map<String, dynamic> map) {
    return ImportedAccountModel(
      mainAddress: map['mainAddress'] ?? '',
      proxyAddress: map['address'] ?? '',
      name: map['name'] ?? '',
      biometricAccess: map['biometricAccess'] ?? false,
      timerInterval: StringUtils.enumFromString<EnumTimerIntervalTypes>(
          EnumTimerIntervalTypes.values, map['timerInterval'] ?? 'oneMinute')!,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'mainAddress': mainAddress,
      'address': proxyAddress,
      'name': name,
      'biometricAccess': biometricAccess,
      'timerInterval': timerInterval.toString(),
    };
  }

  ImportedAccountModel copyWith({
    String? encoded,
    String? mainAddress,
    String? proxyAddress,
    String? name,
    bool? biometricAccess,
    String? signature,
    EnumTimerIntervalTypes? timerInterval,
  }) {
    return ImportedAccountModel(
      mainAddress: mainAddress ?? this.mainAddress,
      proxyAddress: proxyAddress ?? this.proxyAddress,
      name: name ?? this.name,
      biometricAccess: biometricAccess ?? this.biometricAccess,
      timerInterval: timerInterval ?? this.timerInterval,
    );
  }
}
