import 'package:equatable/equatable.dart';
import 'package:polkadex/features/setup/domain/entities/meta_entity.dart';
import 'package:polkadex/features/setup/domain/entities/encoding_entity.dart';

class ImportedTradeAccountEntity extends Equatable {
  const ImportedTradeAccountEntity({
    required this.address,
    required this.encoded,
    required this.encoding,
    required this.meta,
  });

  final String address;
  final String encoded;
  final EncodingEntity encoding;
  final MetaEntity meta;

  @override
  List<Object?> get props => [
        address,
        encoded,
        encoding,
        meta,
      ];
}
