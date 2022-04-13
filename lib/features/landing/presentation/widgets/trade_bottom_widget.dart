import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/features/landing/presentation/cubits/list_orders_cubit/list_orders_cubit.dart';
import 'package:polkadex/features/landing/presentation/widgets/order_item_widget.dart';
import 'package:polkadex/common/cubits/account_cubit.dart';

class TradeBottomWidget extends StatelessWidget {
  final ValueNotifier<EnumTradeBottomDisplayTypes> tradeBottomDisplayNotifier =
      ValueNotifier<EnumTradeBottomDisplayTypes>(
          EnumTradeBottomDisplayTypes.orderHistory);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                  BlocBuilder<ListOrdersCubit, ListOrdersState>(
                    builder: (context, listOrdersState) {
                      return _displayOptionWidget(
                        text:
                            'Order History ${listOrdersState is ListOrdersLoaded ? '(${listOrdersState.openOrders.length})' : ''}',
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
                  SvgPicture.asset(
                    'expand'.asAssetSvg(),
                    width: 14,
                  ),
                ],
              ),
            ),
          ),
        ),
        _listOpenOrders(),
      ],
    );
  }

  Widget _listOpenOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BlocBuilder<ListOrdersCubit, ListOrdersState>(
          builder: (context, state) {
            if (state is ListOrdersLoaded) {
              return Column(
                children: state.openOrders
                    .map<Widget>(
                      (order) => OrderItemWidget(
                        order: order,
                        isProcessing:
                            state.orderIdsLoading.contains(order.orderId),
                        onTapClose: () async {
                          final cancelSuccess = await context
                              .read<ListOrdersCubit>()
                              .cancelOrder(
                                order,
                                context.read<AccountCubit>().accountAddress,
                                context.read<AccountCubit>().accountSignature,
                              );

                          buildAppToast(
                              msg: cancelSuccess
                                  ? 'Order cancelled successfully'
                                  : 'Order cancel failed. Please try again',
                              context: context);
                        },
                      ),
                    )
                    .toList(),
              );
            }

            return Container();
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
                ? Colors.black
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
