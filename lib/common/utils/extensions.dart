import 'dart:convert';

/// The String extension class for the app
///
extension StringExtension on String {
  /// Append the svg location to the string
  String asAssetSvg() => 'assets/svgs/$this.svg';

  /// Append the image location to the string
  String asAssetImg() => 'assets/images/$this';

  String capitalize() => "${this[0].toUpperCase()}${substring(1)}";

  String toBase64() {
    final passwordUtf8 = utf8.encode(this);
    return base64.encode(passwordUtf8);
  }
}

extension DefaultMap<K, V> on Map<K, V> {
  V getBalance(K key) {
    return this[key] ?? ('0.0' as V);
  }
}
