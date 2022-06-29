import 'package:equatable/equatable.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/domain/entities/encoding_entity.dart';
import 'meta_entity.dart';

class ImportedAccountEntity extends Equatable {
  const ImportedAccountEntity({
    required this.encoded,
    required this.encoding,
    required this.mainAddress,
    required this.proxyAddress,
    required this.meta,
    required this.name,
    required this.biometricOnly,
    required this.biometricAccess,
    required this.timerInterval,
  });

  final String encoded;
  final EncodingEntity encoding;
  final String mainAddress;
  final String proxyAddress;
  final MetaEntity meta;
  final String name;
  final bool biometricOnly;
  final bool biometricAccess;
  final EnumTimerIntervalTypes timerInterval;

  @override
  List<Object?> get props => [
        encoded,
        encoding,
        mainAddress,
        proxyAddress,
        meta,
        name,
        biometricAccess,
        timerInterval,
      ];
}
