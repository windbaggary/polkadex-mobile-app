import 'package:equatable/equatable.dart';
import 'package:polkadex/common/utils/enums.dart';

class AccountEntity extends Equatable {
  const AccountEntity({
    required this.name,
    required this.email,
    required this.mainAddress,
    required this.proxyAddress,
    required this.biometricAccess,
    required this.timerInterval,
  });

  final String name;
  final String email;
  final String mainAddress;
  final String proxyAddress;
  final bool biometricAccess;
  final EnumTimerIntervalTypes timerInterval;

  @override
  List<Object?> get props => [
        email,
        mainAddress,
        proxyAddress,
        biometricAccess,
        timerInterval,
      ];
}
