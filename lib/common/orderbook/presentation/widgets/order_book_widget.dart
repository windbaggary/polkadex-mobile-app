import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_item_entity.dart';
import 'package:polkadex/common/orderbook/presentation/cubit/orderbook_cubit.dart';
import 'package:polkadex/common/orderbook/presentation/widgets/orderbook_heading_widget.dart';
import 'package:polkadex/common/widgets/polkadex_progress_error_widget.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:polkadex/common/orderbook/presentation/widgets/order_buy_item_widget.dart';
import 'package:polkadex/common/orderbook/presentation/widgets/order_sell_item_widget.dart';
import 'package:polkadex/common/orderbook/presentation/widgets/orderbook_shimmer_widget.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/styles.dart';

/// The order book widget
class OrderBookWidget extends StatelessWidget {
  const OrderBookWidget({
    required this.amountTokenId,
    required this.priceTokenId,
  });

  final String amountTokenId;
  final String priceTokenId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35, bottom: 96),
      child: BlocBuilder<OrderbookCubit, OrderbookState>(
          builder: (context, state) {
        if (state is OrderbookLoaded) {
          return Column(
            children: [
              OrderBookHeadingWidget(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.only(top: 15, bottom: 13),
                    decoration: BoxDecoration(
                      color: AppColors.color24252C,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.17),
                          blurRadius: 99,
                          offset: Offset(0.0, 100.0),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Latest transaction',
                          style: tsS15W400CFF,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 4),
                          child: Text(
                            '0.0006673',
                            style: tsS20W600CFF.copyWith(
                                color: AppColors.color0CA564),
                          ),
                        ),
                        Text(
                          '~\$32.88',
                          style: tsS15W600CABB2BC,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.color2E303C,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      left: 23,
                      right: 23,
                      bottom: 20,
                    ),
                    child: _ThisOrderBookChartWidget(
                      amountTokenId: amountTokenId,
                      priceTokenId: priceTokenId,
                      buyItems: state.orderbook.bid,
                      sellItems: state.orderbook.ask,
                    ),
                  ),
                ],
              )
            ],
          );
        }

        if (state is OrderbookError) {
          return PolkadexErrorRefreshWidget(
            onRefresh: () => context.read<OrderbookCubit>().fetchOrderbookData(
                leftTokenId: priceTokenId, rightTokenId: amountTokenId),
          );
        }

        return OrderBookShimmerWidget();
      }),
    );
  }
}

/// The widget displays the chart on order book content
class _ThisOrderBookChartWidget extends StatelessWidget {
  _ThisOrderBookChartWidget({
    required this.amountTokenId,
    required this.priceTokenId,
    required this.buyItems,
    required this.sellItems,
  });

  final String amountTokenId;
  final String priceTokenId;
  final List<OrderbookItemEntity> buyItems;
  final List<OrderbookItemEntity> sellItems;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderBookWidgetFilterProvider>();
    Widget child = Container();
    switch (provider.enumBuySellAll) {
      case EnumBuySellAll.buy:
        child = Column(
          key: ValueKey("buy"),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeadingWidget(),
            _buildBuyWidget(buyItems),
          ],
        );
        break;
      case EnumBuySellAll.sell:
        child = Column(
          key: ValueKey("sell"),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeadingWidget(isBuyHeader: false),
            _buildSellWidget(sellItems),
          ],
        );
        break;
      case EnumBuySellAll.all:
        child = Column(
          key: ValueKey("all"),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildHeadingWidget(),
                ),
                SizedBox(width: 7),
                Expanded(
                  child: _buildHeadingWidget(isBuyHeader: false),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildBuyWidget(buyItems),
                ),
                SizedBox(width: 7),
                Expanded(
                  child: _buildSellWidget(sellItems),
                ),
              ],
            ),
          ],
        );
        break;
    }
    return AnimatedSwitcher(
      duration: AppConfigs.animDurationSmall,
      child: child,
    );
  }

  Widget _buildSellWidget(List<OrderbookItemEntity> sellItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
          sellItems.length,
          (index) => OrderSellItemWidget(
                orderbookItem: sellItems[index],
                percentageFilled: sellItems[index].cumulativeAmount /
                    sellItems.last.cumulativeAmount,
              )),
    );
  }

  Widget _buildBuyWidget(List<OrderbookItemEntity> buyItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
          buyItems.length,
          (index) => OrderBuyItemWidget(
                orderbookItem: buyItems[index],
                percentageFilled: buyItems[index].cumulativeAmount /
                    buyItems.last.cumulativeAmount,
              )),
    );
  }

  Widget _buildHeadingWidget({bool isBuyHeader = true}) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 10),
        child: Row(
          children: isBuyHeader
              ? [
                  Expanded(
                    child: Text(
                      'Amount (${TokenUtils.tokenIdToAcronym(amountTokenId)})',
                      style: tsS13W500CFFOP40,
                    ),
                  ),
                  Text(
                    'Price (${TokenUtils.tokenIdToAcronym(priceTokenId)})',
                    style: tsS13W500CFFOP40,
                    textAlign: TextAlign.end,
                  )
                ]
              : [
                  Expanded(
                    child: Text(
                      'Price (${TokenUtils.tokenIdToAcronym(priceTokenId)})',
                      style: tsS13W500CFFOP40,
                    ),
                  ),
                  Text(
                    'Amount (${TokenUtils.tokenIdToAcronym(amountTokenId)})',
                    style: tsS13W500CFFOP40,
                    textAlign: TextAlign.end,
                  )
                ],
        ),
      );
}

class OrderBookWidgetFilterProvider extends ChangeNotifier {
  EnumBuySellAll _enumBuySellAll = EnumBuySellAll.all;

  EnumBuySellAll get enumBuySellAll => _enumBuySellAll;
  set enumBuySellAll(EnumBuySellAll val) {
    _enumBuySellAll = val;
    notifyListeners();
  }
}
