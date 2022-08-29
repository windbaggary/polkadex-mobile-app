import 'package:equatable/equatable.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/domain/entities/imported_trade_account_entity.dart';

class AccountEntity extends Equatable {
  const AccountEntity({
    required this.name,
    required this.email,
    required this.mainAddress,
    required this.biometricAccess,
    required this.timerInterval,
    this.importedTradeAccountEntity,
  });

  final String name;
  final String email;
  final String mainAddress;
  final bool biometricAccess;
  final EnumTimerIntervalTypes timerInterval;
  final ImportedTradeAccountEntity? importedTradeAccountEntity;

  @override
  List<Object?> get props => [
        name,
        email,
        mainAddress,
        biometricAccess,
        timerInterval,
        importedTradeAccountEntity,
      ];
}
