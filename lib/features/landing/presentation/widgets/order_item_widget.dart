import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/features/landing/domain/entities/order_entity.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({
    required this.order,
    this.isProcessing = false,
    this.onTapClose,
  });

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
            Container(
              decoration: BoxDecoration(
                color: AppColors.colorFFFFFF.withOpacity(0.05),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.17),
                    blurRadius: 99,
                    offset: Offset(0.0, 100.0),
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.fromLTRB(27, 13, 19, 7),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.color8BA1BE.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    margin: const EdgeInsets.only(right: 9),
                    child: Text(
                      order.iOrderTypeName,
                      style: tsS16W500CFF,
                    ),
                  ),
                  Text(
                    '${TokenUtils.tokenIdToAcronym(order.baseAsset)}/${TokenUtils.tokenIdToAcronym(order.quoteAsset)}',
                    style: tsS15W600CFF,
                  ),
                  Spacer(),
                  InkWell(
                    onTap: onTapClose,
                    child: SvgPicture.asset(
                      'close'.asAssetSvg(),
                      width: 10,
                      height: 10,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.color2E303C,
                borderRadius: BorderRadius.circular(16),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.17),
                    blurRadius: 99,
                    offset: Offset(0.0, 100.0),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(15, 15, 13, 19),
              margin: const EdgeInsets.only(left: 13, right: 13, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 75,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Type',
                              style: tsS14W400CFF.copyWith(
                                  color: AppColors.colorABB2BC),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: colorBuySell.withOpacity(0.20),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              child: Text(
                                order.iType,
                                style: tsS16W500CFF.copyWith(
                                  color: colorBuySell,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amount',
                              style: tsS14W400CFF.copyWith(
                                  color: AppColors.colorABB2BC),
                            ),
                            SizedBox(height: 4),
                            Text(
                              order.iAmount,
                              style: tsS16W500CFF,
                            )
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: tsS14W400CFF.copyWith(
                                color: AppColors.colorABB2BC),
                          ),
                          Text(
                            order.iPrice,
                            style: tsS16W500CFF,
                          )
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      order.iFormattedDate,
                      style:
                          tsS14W400CFF.copyWith(color: AppColors.colorABB2BC),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
