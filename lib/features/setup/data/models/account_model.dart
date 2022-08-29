import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/string_utils.dart';
import 'package:polkadex/features/setup/data/models/imported_trade_account_model.dart';
import 'package:polkadex/features/setup/domain/entities/account_entity.dart';
import 'package:polkadex/features/setup/domain/entities/imported_trade_account_entity.dart';

class AccountModel extends AccountEntity {
  const AccountModel({
    required String name,
    required String email,
    required String mainAddress,
    required bool biometricAccess,
    required EnumTimerIntervalTypes timerInterval,
    ImportedTradeAccountEntity? importedTradeAccountEntity,
  }) : super(
          name: name,
          email: email,
          mainAddress: mainAddress,
          biometricAccess: biometricAccess,
          timerInterval: timerInterval,
          importedTradeAccountEntity: importedTradeAccountEntity,
        );

  factory AccountModel.fromJson(Map<String, dynamic> map) {
    return AccountModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      mainAddress: map['mainAddress'] ?? '',
      biometricAccess: map['biometricAccess'] ?? false,
      timerInterval: StringUtils.enumFromString<EnumTimerIntervalTypes>(
          EnumTimerIntervalTypes.values, map['timerInterval'] ?? 'oneMinute')!,
      importedTradeAccountEntity:
          ImportedTradeAccountModel.fromJson(map['importedTradeAccountEntity']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'mainAddress': mainAddress,
      'biometricAccess': biometricAccess,
      'timerInterval': timerInterval.toString(),
      'importedTradeAccountEntity': importedTradeAccountEntity != null
          ? (importedTradeAccountEntity as ImportedTradeAccountModel).toJson()
          : null,
    };
  }

  AccountModel copyWith({
    String? name,
    String? email,
    String? mainAddress,
    bool? biometricAccess,
    EnumTimerIntervalTypes? timerInterval,
    ImportedTradeAccountEntity? importedTradeAccountEntity,
  }) {
    return AccountModel(
      name: name ?? this.name,
      email: email ?? this.email,
      mainAddress: mainAddress ?? this.mainAddress,
      biometricAccess: biometricAccess ?? this.biometricAccess,
      timerInterval: timerInterval ?? this.timerInterval,
      importedTradeAccountEntity:
          importedTradeAccountEntity ?? this.importedTradeAccountEntity,
    );
  }
}
