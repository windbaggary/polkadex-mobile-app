import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/string_utils.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';

class ImportedAccountModel extends ImportedAccountEntity {
  const ImportedAccountModel({
    required String email,
    required String mainAddress,
    required String proxyAddress,
    required bool biometricAccess,
    required EnumTimerIntervalTypes timerInterval,
  }) : super(
          email: email,
          mainAddress: mainAddress,
          proxyAddress: proxyAddress,
          biometricAccess: biometricAccess,
          timerInterval: timerInterval,
        );

  factory ImportedAccountModel.fromJson(Map<String, dynamic> map) {
    return ImportedAccountModel(
      email: map['email'] ?? '',
      mainAddress: map['mainAddress'] ?? '',
      proxyAddress: map['address'] ?? '',
      biometricAccess: map['biometricAccess'] ?? false,
      timerInterval: StringUtils.enumFromString<EnumTimerIntervalTypes>(
          EnumTimerIntervalTypes.values, map['timerInterval'] ?? 'oneMinute')!,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'mainAddress': mainAddress,
      'address': proxyAddress,
      'biometricAccess': biometricAccess,
      'timerInterval': timerInterval.toString(),
    };
  }

  ImportedAccountModel copyWith({
    String? email,
    String? mainAddress,
    String? proxyAddress,
    bool? biometricAccess,
    String? signature,
    EnumTimerIntervalTypes? timerInterval,
  }) {
    return ImportedAccountModel(
      email: email ?? this.email,
      mainAddress: mainAddress ?? this.mainAddress,
      proxyAddress: proxyAddress ?? this.proxyAddress,
      biometricAccess: biometricAccess ?? this.biometricAccess,
      timerInterval: timerInterval ?? this.timerInterval,
    );
  }
}
