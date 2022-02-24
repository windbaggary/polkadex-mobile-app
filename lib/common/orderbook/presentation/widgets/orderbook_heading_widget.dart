import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/features/landing/presentation/dialogs/trade_view_dialogs.dart';

import 'order_book_widget.dart';

/// The heading widget for the order book
class OrderBookHeadingWidget extends StatelessWidget {
  OrderBookHeadingWidget({required this.priceLengthNotifier});

  final ValueNotifier<int> priceLengthNotifier;
  final _dropDownValueNotifier = ValueNotifier<String>("Order Book");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: [
          Expanded(
            // width: 100,
            child: ValueListenableBuilder<String>(
              valueListenable: _dropDownValueNotifier,
              builder: (context, dropDownValue, child) =>
                  DropdownButton<String>(
                items: ['Order Book', 'Deep Market']
                    .map((e) => DropdownMenuItem<String>(
                          child: Text(
                            e,
                            style: tsS20W600CFF,
                          ),
                          value: e,
                        ))
                    .toList(),
                value: dropDownValue,
                style: tsS20W600CFF,
                underline: Container(),
                onChanged: (val) {
                  _dropDownValueNotifier.value = val!;
                },
                isExpanded: false,
                icon: Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.colorFFFFFF,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
          ...EnumBuySellAll.values
              .map(
                (e) => Consumer<OrderBookWidgetFilterProvider>(
                  builder: (context, provider, child) {
                    String svg;
                    double padding = 8;
                    Color color = AppColors.color2E303C;

                    switch (e) {
                      case EnumBuySellAll.buy:
                        svg = 'orderbookBuy'.asAssetSvg();
                        if (provider.enumBuySellAll == EnumBuySellAll.buy) {
                          svg = 'orderbookBuySel'.asAssetSvg();
                        }
                        break;
                      case EnumBuySellAll.all:
                        svg = 'orderbookAll'.asAssetSvg();

                        break;
                      case EnumBuySellAll.sell:
                        svg = 'orderbookSell'.asAssetSvg();
                        if (provider.enumBuySellAll == EnumBuySellAll.sell) {
                          svg = 'orderbookSellSel'.asAssetSvg();
                        }
                        break;
                    }

                    if (provider.enumBuySellAll == e) {
                      padding = 5;
                      color = Colors.white;
                    }
                    return InkWell(
                      onTap: () {
                        provider.enumBuySellAll = e;
                      },
                      child: AnimatedContainer(
                        duration: AppConfigs.animDurationSmall,
                        padding: EdgeInsets.all(padding),
                        margin: const EdgeInsets.only(right: 7),
                        width: 31,
                        height: 31,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withOpacity(0.17),
                              blurRadius: 99,
                              offset: Offset(0.0, 100.0),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(svg),
                      ),
                    );
                  },
                ),
              )
              .toList(),
          InkWell(
            onTap: () {
              showPriceLengthDialog(
                context: context,
                selectedIndex: priceLengthNotifier.value,
                onItemSelected: (index) => priceLengthNotifier.value = index,
              );
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2, right: 4),
                  child: ValueListenableBuilder<int>(
                    valueListenable: priceLengthNotifier,
                    builder: (context, selectedPriceLenIndex, child) => Text(
                      dummyPriceLengthData[selectedPriceLenIndex].price,
                      style: tsS15W600CFF.copyWith(
                          color: AppColors.colorFFFFFF.withOpacity(0.30)),
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.colorFFFFFF,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
