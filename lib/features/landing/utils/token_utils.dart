import 'package:polkadex/common/utils/extensions.dart';

abstract class TokenUtils {
  static String tokenIdToFullName(String acronym) {
    switch (acronym) {
      case '0':
        return 'PolkaDoge';
      case '1':
        return 'ShibaDex';
      default:
        return 'Token';
    }
  }

  static String tokenIdToAcronym(String acronym) {
    switch (acronym) {
      case '0':
        return 'PDG';
      case '1':
        return 'SDX';
      default:
        return 'TKN';
    }
  }

  static String tokenIdToAssetSvg(String acronym) {
    switch (acronym) {
      case 'PDEX':
        return 'polkadex_white'.asAssetSvg();
      default:
        return 'unknow_white'.asAssetSvg();
    }
  }
}
