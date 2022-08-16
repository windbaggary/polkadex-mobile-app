import 'package:equatable/equatable.dart';
import 'package:polkadex/common/utils/enums.dart';

class ImportedAccountEntity extends Equatable {
  const ImportedAccountEntity({
    required this.mainAddress,
    required this.proxyAddress,
    required this.name,
    required this.biometricAccess,
    required this.timerInterval,
  });

  final String mainAddress;
  final String proxyAddress;
  final String name;
  final bool biometricAccess;
  final EnumTimerIntervalTypes timerInterval;

  @override
  List<Object?> get props => [
        mainAddress,
        proxyAddress,
        name,
        biometricAccess,
        timerInterval,
      ];
}
