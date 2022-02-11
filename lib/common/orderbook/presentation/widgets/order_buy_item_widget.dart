import 'package:flutter/material.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_item_entity.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/orderbook/presentation/widgets/order_book_chart_item.dart';

class OrderBuyItemWidget extends StatelessWidget {
  const OrderBuyItemWidget({
    required this.orderbookItem,
    required this.percentageFilled,
  });

  final OrderbookItemEntity orderbookItem;
  final double percentageFilled;

  @override
  Widget build(BuildContext context) {
    return OrderBookChartItemWidget(
      percentage: percentageFilled,
      direction: EnumGradientDirection.right,
      color: AppColors.color0CA564,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 6, 6, 6),
        child: Row(
          children: [
            Expanded(
              child: Text(
                orderbookItem.amount.toStringAsFixed(4),
                style: tsS14W500CFF,
              ),
            ),
            Text(
              orderbookItem.price.toStringAsFixed(4),
              style: tsS14W500CFF.copyWith(color: AppColors.color0CA564),
            ),
          ],
        ),
      ),
    );
  }
}
