import 'package:polkadex/common/utils/extensions.dart';

abstract class TokenUtils {
  static String tokenAcronymToFullName(String acronym) {
    switch (acronym) {
      case 'ETH':
        return 'Ethereum';
      case 'PDEX':
        return 'Polkadex';
      case 'LTC':
        return 'Litecoin';
      default:
        return 'Bitcoin';
    }
  }

  static String tokenAcronymToAssetImg(String acronym) {
    switch (acronym) {
      case 'ETH':
        return 'trade_open/trade_open_1.png'.asAssetImg();
      case 'PDEX':
        return 'trade_open/trade_open_2.png'.asAssetImg();
      case 'LTC':
        return 'trade_open/trade_open_9.png'.asAssetImg();
      default:
        return 'trade_open/trade_open_11.png'.asAssetImg();
    }
  }
}
