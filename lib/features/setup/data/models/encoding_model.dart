import 'package:polkadex/features/setup/domain/entities/encoding_entity.dart';

class EncodingModel extends EncodingEntity {
  const EncodingModel({
    required List<String> content,
    required List<String> type,
    required String version,
  }) : super(
          content: content,
          type: type,
          version: version,
        );

  factory EncodingModel.fromJson(Map<String, dynamic> map) {
    return EncodingModel(
      content: map['content'].cast<String>(),
      type: map['type'].cast<String>(),
      version: map['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'content': content,
      'type': type,
      'version': version,
    };
  }
}
