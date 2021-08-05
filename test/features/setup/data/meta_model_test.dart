import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/setup/data/models/meta_model.dart';
import 'package:polkadex/features/setup/domain/entities/meta_entity.dart';

void main() {
  MetaModel? tMeta;

  setUp(() {
    tMeta = MetaModel(name: 'userName');
  });

  test('MetaModel must be a MetaEntity', () async {
    expect(tMeta, isA<MetaEntity>());
  });
}
