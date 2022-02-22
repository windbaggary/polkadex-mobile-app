import 'package:equatable/equatable.dart';
import 'package:polkadex/features/setup/domain/entities/encoding_entity.dart';
import 'meta_entity.dart';

class ImportedAccountEntity extends Equatable {
  const ImportedAccountEntity({
    required this.encoded,
    required this.encoding,
    required this.address,
    required this.meta,
    required this.name,
    required this.biometricOnly,
    required this.biometricAccess,
    required this.signature,
  });

  final String encoded;
  final EncodingEntity encoding;
  final String address;
  final MetaEntity meta;
  final String name;
  final bool biometricOnly;
  final bool biometricAccess;
  final String signature;

  @override
  List<Object?> get props => [
        encoded,
        encoding,
        address,
        meta,
        name,
        biometricAccess,
        signature,
      ];
}
