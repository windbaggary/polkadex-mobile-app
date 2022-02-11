import 'package:flutter/material.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_item_entity.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/orderbook/presentation/widgets/order_book_chart_item.dart';

class OrderSellItemWidget extends StatelessWidget {
  const OrderSellItemWidget({
    required this.orderbookItem,
    required this.percentageFilled,
  });

  final OrderbookItemEntity orderbookItem;
  final double percentageFilled;

  @override
  Widget build(BuildContext context) {
    return OrderBookChartItemWidget(
      percentage: percentageFilled,
      color: AppColors.colorE6007A,
      direction: EnumGradientDirection.left,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6.0, 6, 0, 6),
        child: Row(
          children: [
            Text(
              orderbookItem.price.toStringAsFixed(4),
              style: tsS14W500CFF.copyWith(color: AppColors.colorE6007A),
            ),
            Expanded(
              child: Text(
                orderbookItem.amount.toStringAsFixed(4),
                style: tsS14W500CFF,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
