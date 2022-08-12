import 'package:polkadex/common/utils/extensions.dart';

abstract class TokenUtils {
  static String tokenIdToAssetSvg(String acronym) {
    switch (acronym) {
      case 'PDEX':
        return 'polkadex_white'.asAssetSvg();
      default:
        return 'unknow_white'.asAssetSvg();
    }
  }
}
