import 'package:flutter/material.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';

class BuySellWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_orderSideButton(), _orderSideButton(isBuy: false)],
    );
  }

  Widget _orderSideButton({bool isBuy = true}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.color3B4150,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(vertical: 20),
      width: (AppConfigs.size.width / 4) - 6,
      child: Align(
        alignment: Alignment.center,
        child: isBuy
            ? Text(
                'Buy',
                style: tsS13W600CFF,
              )
            : Text(
                'Sell',
                style: tsS13W600CFF,
              ),
      ),
    );
  }
}
