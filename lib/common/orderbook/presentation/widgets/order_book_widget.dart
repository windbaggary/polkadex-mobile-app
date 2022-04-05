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
  OrderBookWidget({
    required this.amountTokenId,
    required this.priceTokenId,
  });

  final String amountTokenId;
  final String priceTokenId;
  final ValueNotifier<int> priceLengthNotifier = ValueNotifier<int>(0);
  final ValueNotifier<EnumMarketDropdownTypes> marketDropDownNotifier =
      ValueNotifier<EnumMarketDropdownTypes>(EnumMarketDropdownTypes.orderbook);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35, bottom: 96),
      child: BlocBuilder<OrderbookCubit, OrderbookState>(
          builder: (context, state) {
        if (state is OrderbookLoaded) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: OrderBookHeadingWidget(
                  marketDropDownNotifier: marketDropDownNotifier,
                  priceLengthNotifier: priceLengthNotifier,
                ),
              ),
              ValueListenableBuilder<EnumMarketDropdownTypes>(
                valueListenable: marketDropDownNotifier,
                builder: (context, dropdownMarketIndex, child) {
                  return ValueListenableBuilder<int>(
                    valueListenable: priceLengthNotifier,
                    builder: (context, selectedPriceLenIndex, child) {
                      return _ThisOrderBookChartWidget(
                        amountTokenId: amountTokenId,
                        priceTokenId: priceTokenId,
                        buyItems: state.orderbook.bid,
                        sellItems: state.orderbook.ask,
                        marketDropDownNotifier: marketDropDownNotifier,
                        priceLengthNotifier: priceLengthNotifier,
                      );
                    },
                  );
                },
              ),
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
    required this.marketDropDownNotifier,
    required this.priceLengthNotifier,
    this.horizontalPadding = 8,
  });

  final String amountTokenId;
  final String priceTokenId;
  final List<OrderbookItemEntity> buyItems;
  final List<OrderbookItemEntity> sellItems;
  final ValueNotifier<EnumMarketDropdownTypes> marketDropDownNotifier;
  final ValueNotifier<int> priceLengthNotifier;
  final double horizontalPadding;

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
            _buildLatestTransactionWidget(),
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
            _buildLatestTransactionWidget(),
          ],
        );
        break;
      case EnumBuySellAll.all:
        child = Column(
          key: ValueKey("all"),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeadingWidget(isBuyHeader: false),
            _buildSellWidget(sellItems),
            _buildBuyWidget(buyItems),
            _buildLatestTransactionWidget(),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
            sellItems.length,
            (index) => OrderSellItemWidget(
                  orderbookItem: sellItems[index],
                  percentageFilled: sellItems[index].cumulativeAmount /
                      sellItems.last.cumulativeAmount,
                  marketDropDownNotifier: marketDropDownNotifier,
                  priceLengthNotifier: priceLengthNotifier,
                )),
      ),
    );
  }

  Widget _buildBuyWidget(List<OrderbookItemEntity> buyItems) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
            buyItems.length,
            (index) => OrderBuyItemWidget(
                  orderbookItem: buyItems[index],
                  percentageFilled: buyItems[index].cumulativeAmount /
                      buyItems.last.cumulativeAmount,
                  marketDropDownNotifier: marketDropDownNotifier,
                  priceLengthNotifier: priceLengthNotifier,
                )),
      ),
    );
  }

  Widget _buildHeadingWidget({bool isBuyHeader = true}) {
    final String amountColumnTitle =
        marketDropDownNotifier.value == EnumMarketDropdownTypes.depthmarket
            ? 'Cum'
            : 'Amount';

    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        top: 16,
        right: horizontalPadding,
        bottom: 10,
      ),
      child: Row(
        children: isBuyHeader
            ? [
                Expanded(
                  child: Text(
                    '$amountColumnTitle (${TokenUtils.tokenIdToAcronym(amountTokenId)})',
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
                  '$amountColumnTitle (${TokenUtils.tokenIdToAcronym(amountTokenId)})',
                  style: tsS13W500CFFOP40,
                  textAlign: TextAlign.end,
                )
              ],
      ),
    );
  }

  Widget _buildLatestTransactionWidget({bool isDownTendency = true}) {
    return Padding(
      padding: EdgeInsets.only(
        top: 8.0,
        right: horizontalPadding,
        bottom: 8.0,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 18,
          horizontal: horizontalPadding,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isDownTendency ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isDownTendency
                      ? AppColors.colorE6007A
                      : AppColors.color0CA564,
                  size: 18,
                ),
                Text(
                  '0.218580',
                  style: isDownTendency ? tsS18W600CE6007A : tsS18W600C0CA564,
                ),
              ],
            ),
            Text(
              '\$24.00',
              style: tsS14W400C93949A,
            )
          ],
        ),
      ),
    );
  }
}

class OrderBookWidgetFilterProvider extends ChangeNotifier {
  EnumBuySellAll _enumBuySellAll = EnumBuySellAll.all;

  EnumBuySellAll get enumBuySellAll => _enumBuySellAll;
  set enumBuySellAll(EnumBuySellAll val) {
    _enumBuySellAll = val;
    notifyListeners();
  }
}
