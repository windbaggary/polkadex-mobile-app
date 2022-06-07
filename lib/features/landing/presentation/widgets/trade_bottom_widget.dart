import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/widgets/polkadex_progress_error_widget.dart';
import 'package:polkadex/common/trades/presentation/cubits/order_history_cubit/order_history_cubit.dart';
import 'package:polkadex/features/landing/presentation/widgets/order_item_widget.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:shimmer/shimmer.dart';

class TradeBottomWidget extends StatelessWidget {
  final ValueNotifier<EnumTradeBottomDisplayTypes> tradeBottomDisplayNotifier =
      ValueNotifier<EnumTradeBottomDisplayTypes>(
          EnumTradeBottomDisplayTypes.orderHistory);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(8),
          child: ValueListenableBuilder<EnumTradeBottomDisplayTypes>(
            valueListenable: tradeBottomDisplayNotifier,
            builder: (context, optionDisplayValue, _) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
                    builder: (context, orderHistoryState) {
                      return _displayOptionWidget(
                        text:
                            'Order History  ${orderHistoryState is OrderHistoryLoaded ? '(${orderHistoryState.orders.length})' : ''}',
                        enumValue: EnumTradeBottomDisplayTypes.orderHistory,
                      );
                    },
                  ),
                  _displayOptionWidget(
                    text: 'Trade History',
                    enumValue: EnumTradeBottomDisplayTypes.tradeHistory,
                    enabled: false,
                  ),
                  _displayOptionWidget(
                    text: 'Funds',
                    enumValue: EnumTradeBottomDisplayTypes.funds,
                    enabled: false,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        _listOpenOrders(),
      ],
    );
  }

  Widget _listOpenOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
          builder: (context, orderHistoryState) {
            if (orderHistoryState is OrderHistoryLoaded) {
              return Column(
                children: orderHistoryState.orders
                    .map<Widget>(
                      (order) => Column(
                        children: [
                          OrderItemWidget(
                            order: order,
                            isProcessing: orderHistoryState.orderIdsLoading
                                .contains(order.orderId),
                            onTapClose: () async {
                              final cancelSuccess = await context
                                  .read<OrderHistoryCubit>()
                                  .cancelOrder(
                                    order,
                                    context.read<AccountCubit>().accountAddress,
                                    context
                                        .read<AccountCubit>()
                                        .accountSignature,
                                  );
//
                              buildAppToast(
                                  msg: cancelSuccess
                                      ? 'Order cancelled successfully'
                                      : 'Order cancel failed. Please try again',
                                  context: context);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Divider(
                              color: AppColors.color558BA1BE,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              );
            }

            if (orderHistoryState is OrderHistoryError) {
              return PolkadexErrorRefreshWidget(
                onRefresh: () => context.read<OrderHistoryCubit>().getOrders(
                      context
                          .read<MarketAssetCubit>()
                          .currentBaseAssetDetails
                          .assetId,
                      context.read<AccountCubit>().accountAddress,
                      context.read<AccountCubit>().accountSignature,
                      false,
                    ),
              );
            }

            return _shimmerWidget();
          },
        ),
      ],
    );
  }

  Widget _shimmerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
          builder: (context, orderHistoryState) {
            return Shimmer.fromColors(
              highlightColor: AppColors.color8BA1BE,
              baseColor: AppColors.color2E303C,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black,
                ),
                height: 240,
                child: Container(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _displayOptionWidget({
    required String text,
    required EnumTradeBottomDisplayTypes enumValue,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTapDown: enabled
          ? (_) => tradeBottomDisplayNotifier.value = enumValue
          : (_) {},
      child: Opacity(
        opacity: enabled ? 1.0 : 0.3,
        child: Container(
          decoration: BoxDecoration(
            color: tradeBottomDisplayNotifier.value == enumValue
                ? AppColors.color24252C
                : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              if (enumValue == EnumTradeBottomDisplayTypes.orderHistory)
                SvgPicture.asset(
                  'orders'.asAssetSvg(),
                  width: 14,
                  color: tradeBottomDisplayNotifier.value == enumValue
                      ? Colors.white
                      : AppColors.color141415,
                ),
              SizedBox(width: 6),
              Text(
                text,
                style: tradeBottomDisplayNotifier.value == enumValue
                    ? tsS16W600CFF
                    : tsS16W600C141415,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
