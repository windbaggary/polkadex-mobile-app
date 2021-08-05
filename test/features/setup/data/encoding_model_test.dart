import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/setup/data/models/encoding_model.dart';
import 'package:polkadex/features/setup/domain/entities/encoding_entity.dart';

void main() {
  EncodingModel? tEncoding;

  setUp(() {
    tEncoding = EncodingModel(
      content: ["sr25519"],
      version: '3',
      type: ["none"],
    );
  });

  test('EncodingModel must be a EncodingEntity', () async {
    expect(tEncoding, isA<EncondingEntity>());
  });
}
