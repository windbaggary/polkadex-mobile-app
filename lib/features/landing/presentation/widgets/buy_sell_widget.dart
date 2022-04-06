import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/enums.dart';

class BuySellWidget extends StatelessWidget {
  const BuySellWidget({required this.buySellNotifier});

  final ValueNotifier<EnumBuySell> buySellNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EnumBuySell>(
      valueListenable: buySellNotifier,
      builder: (context, buySellValue, _) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTapDown: (_) => buySellNotifier.value = EnumBuySell.buy,
            child: _orderSideButton(isActive: buySellValue == EnumBuySell.buy),
          ),
          GestureDetector(
            onTapDown: (_) => buySellNotifier.value = EnumBuySell.sell,
            child: _orderSideButton(
              isActive: buySellValue == EnumBuySell.sell,
              isBuy: false,
            ),
          )
        ],
      ),
    );
  }

  Widget _orderSideButton({
    bool isActive = false,
    bool isBuy = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? (isBuy ? AppColors.color0CA564 : AppColors.colorE6007A)
            : AppColors.color3B4150,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(vertical: 20),
      width: (AppConfigs.size.width / 4) - 6,
      child: Align(
        alignment: Alignment.center,
        child: isBuy
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'buy_circle'.asAssetSvg(),
                    height: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Buy',
                    style: tsS16W600CFF,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'sell_circle'.asAssetSvg(),
                    height: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Sell',
                    style: tsS16W600CFF,
                  ),
                ],
              ),
      ),
    );
  }
}
