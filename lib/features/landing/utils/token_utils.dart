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
        return 'PDOG';
      case '1':
        return 'SDEX';
      default:
        return 'TKN';
    }
  }

  static String tokenIdToAssetImg(String acronym) {
    switch (acronym) {
      case '0':
        return 'trade_open/trade_open_5.png'.asAssetImg();
      case '1':
        return 'trade_open/trade_open_13.png'.asAssetImg();
      default:
        return 'trade_open/trade_open_11.png'.asAssetImg();
    }
  }
}
