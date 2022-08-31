import 'package:flutter/material.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_item_entity.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/orderbook/presentation/widgets/order_book_chart_item.dart';

class OrderBuyItemWidget extends StatelessWidget {
  const OrderBuyItemWidget({
    required this.orderbookItem,
    required this.percentageFilled,
    required this.marketDropDownNotifier,
    required this.priceLengthNotifier,
  });

  final OrderbookItemEntity orderbookItem;
  final double percentageFilled;
  final ValueNotifier<EnumMarketDropdownTypes> marketDropDownNotifier;
  final ValueNotifier<int> priceLengthNotifier;

  @override
  Widget build(BuildContext context) {
    return OrderBookChartItemWidget(
      percentage: percentageFilled,
      direction: EnumGradientDirection.left,
      color: AppColors.color0CA564,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 6, 6, 6),
        child: Row(
          children: [
            Expanded(
              child: Text(
                orderbookItem.price
                    .toStringAsFixed(priceLengthNotifier.value + 1),
                style: tsS14W500CFF.copyWith(color: AppColors.color0CA564),
              ),
            ),
            Text(
              orderbookItem.amount
                  .toStringAsFixed(priceLengthNotifier.value + 1),
              style: tsS14W500CFF,
            ),
          ],
        ),
      ),
    );
  }
}
