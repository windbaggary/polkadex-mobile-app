import 'package:polkadex/features/setup/domain/entities/meta_entity.dart';

class MetaModel extends MetaEntity {
  const MetaModel({String? name}) : super(name: name);

  factory MetaModel.fromJson(Map<String, dynamic> map) {
    return MetaModel(
      name: map['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name};
  }
}
