import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart';

abstract class StringUtils {
  static String generateCryptoRandomString({int length = 64}) {
    Random _random = Random.secure();
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }

  static T? enumFromString<T>(Iterable<T> values, String value) {
    return values.firstWhereOrNull((type) =>
        type.toString().split(".").last.toLowerCase() ==
        value.split(".").last.toLowerCase());
  }

  static String formatAssetString(String asset) =>
      asset == 'polkadex' ? 'PDEX' : asset;
}
