import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/orders/domain/entities/order_entity.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({
    required this.order,
    this.isProcessing = false,
    this.onTapClose,
  });

  //InkWell(
  //onTap: onTapClose,
  //child: SvgPicture.asset(
  //'close'.asAssetSvg(),
  //width: 10,
  //height: 10,
  //fit: BoxFit.contain,
  //),
  //),

  final OrderEntity order;
  final bool isProcessing;
  final VoidCallback? onTapClose;

  @override
  Widget build(BuildContext context) {
    Color colorBuySell = AppColors.color0CA564;
    if (order.iEnumType == EnumBuySell.sell) {
      colorBuySell = AppColors.colorE6007A;
    }
    return IgnorePointer(
      ignoring: isProcessing,
      child: Opacity(
        opacity: isProcessing ? 0.3 : 1.0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 8, 16, 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amount (${order.baseToken})',
                              style: tsS14W400CFF.copyWith(
                                  color: AppColors.colorABB2BC),
                            ),
                            SizedBox(height: 4),
                            Text(
                              order.amount,
                              style: tsS16W500CFF,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price (${order.quoteToken})',
                              style: tsS14W400CFF.copyWith(
                                  color: AppColors.colorABB2BC),
                            ),
                            SizedBox(height: 4),
                            Text(
                              order.price,
                              style: tsS16W500CFF,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Type',
                              style: tsS14W400CFF.copyWith(
                                  color: AppColors.colorABB2BC),
                            ),
                            SizedBox(height: 4),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.color8BA1BE.withOpacity(0.20),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              child: Text(
                                order.iOrderTypeName,
                                style: tsS16W500CFF,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: colorBuySell.withOpacity(0.20),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: Text(
                          order.iType,
                          style: tsS16W500CFF.copyWith(
                            color: colorBuySell,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order.iTokenPairName,
                          style: tsS14W400CFF.copyWith(
                              color: AppColors.colorABB2BC),
                        ),
                      ),
                      Text(
                        order.iFormattedDate,
                        style:
                            tsS14W400CFF.copyWith(color: AppColors.colorABB2BC),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                color: AppColors.color558BA1BE,
                thickness: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
