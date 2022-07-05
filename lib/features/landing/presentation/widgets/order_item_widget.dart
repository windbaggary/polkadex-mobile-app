import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';

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
    final cubit = context.read<MarketAssetCubit>();

    Color colorBuySell = AppColors.color0CA564;
    if (order.orderSide == EnumBuySell.sell) {
      colorBuySell = AppColors.colorE6007A;
    }
    return IgnorePointer(
      ignoring: isProcessing,
      child: Opacity(
        opacity: isProcessing ? 0.3 : 1.0,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 32,
            right: 16,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amount (${cubit.getAssetDetailsById(order.baseAsset).symbol})',
                              style: tsS14W400CFF.copyWith(
                                  color: AppColors.colorABB2BC),
                            ),
                            SizedBox(height: 4),
                            Text(
                              order.qty,
                              style: tsS16W500CFF,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price (${cubit.getAssetDetailsById(order.quoteAsset).symbol})',
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
                        Column(
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
                            '${cubit.getAssetDetailsById(order.baseAsset).symbol}/${cubit.getAssetDetailsById(order.quoteAsset).symbol}',
                            style: tsS14W400CFF.copyWith(
                                color: AppColors.colorABB2BC),
                          ),
                        ),
                        Text(
                          order.iFormattedDate,
                          style: tsS14W400CFF.copyWith(
                              color: AppColors.colorABB2BC),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: InkWell(
                  onTap: order.status == 'PartiallyFilled' ? onTapClose : () {},
                  child: SvgPicture.asset(
                    'close'.asAssetSvg(),
                    color: order.status == 'PartiallyFilled'
                        ? Colors.white
                        : Colors.transparent,
                    width: 10,
                    height: 10,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
