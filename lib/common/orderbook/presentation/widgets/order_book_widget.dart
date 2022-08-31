import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_item_entity.dart';
import 'package:polkadex/common/orderbook/presentation/cubit/orderbook_cubit.dart';
import 'package:polkadex/common/orderbook/presentation/widgets/orderbook_heading_widget.dart';
import 'package:polkadex/common/orderbook/presentation/widgets/order_buy_item_widget.dart';
import 'package:polkadex/common/orderbook/presentation/widgets/order_sell_item_widget.dart';
import 'package:polkadex/common/orderbook/presentation/widgets/orderbook_shimmer_widget.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/polkadex_progress_error_widget.dart';
import 'package:polkadex/features/landing/presentation/cubits/recent_trades_cubit/recent_trades_cubit.dart';
import 'package:shimmer/shimmer.dart';

/// The order book widget
class OrderBookWidget extends StatelessWidget {
  OrderBookWidget({
    required this.amountToken,
    required this.priceToken,
  });

  final AssetEntity amountToken;
  final AssetEntity priceToken;
  final ValueNotifier<int> priceLengthNotifier = ValueNotifier<int>(0);
  final ValueNotifier<EnumMarketDropdownTypes> marketDropDownNotifier =
      ValueNotifier<EnumMarketDropdownTypes>(EnumMarketDropdownTypes.orderbook);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderbookCubit, OrderbookState>(
      builder: (context, state) {
        if (state is OrderbookLoaded) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
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
                        amountToken: amountToken,
                        priceToken: priceToken,
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
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
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
                        amountToken: amountToken,
                        priceToken: priceToken,
                        buyItems: [],
                        sellItems: [],
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

        return OrderBookShimmerWidget();
      },
    );
  }
}

/// The widget displays the chart on order book content
class _ThisOrderBookChartWidget extends StatelessWidget {
  _ThisOrderBookChartWidget({
    required this.amountToken,
    required this.priceToken,
    required this.buyItems,
    required this.sellItems,
    required this.marketDropDownNotifier,
    required this.priceLengthNotifier,
  });

  final AssetEntity amountToken;
  final AssetEntity priceToken;
  final List<OrderbookItemEntity> buyItems;
  final List<OrderbookItemEntity> sellItems;
  final ValueNotifier<EnumMarketDropdownTypes> marketDropDownNotifier;
  final ValueNotifier<int> priceLengthNotifier;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderBookWidgetFilterProvider>();
    List<Widget> columnChildren;

    switch (provider.enumBuySellAll) {
      case EnumBuySellAll.buy:
        columnChildren = [
          _buildBuyWidget(buyItems),
          _buildLatestTransactionWidget(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [],
          ),
        ];
        break;
      case EnumBuySellAll.sell:
        columnChildren = [
          _buildSellWidget(sellItems),
          _buildLatestTransactionWidget(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [],
          ),
        ];
        break;
      case EnumBuySellAll.all:
        columnChildren = [
          _buildSellWidget(sellItems),
          _buildLatestTransactionWidget(),
          _buildBuyWidget(buyItems),
        ];
        break;
    }

    return AnimatedSwitcher(
      duration: AppConfigs.animDurationSmall,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeadingWidget(),
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 430),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: columnChildren,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSellWidget(List<OrderbookItemEntity> sellItems) {
    List<double> cumulativeAmount = _buildCumulativeAmountList(
      items: sellItems,
      isAscendingOrder: false,
    );

    return Padding(
      padding: EdgeInsets.only(left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
            sellItems.length,
            (index) => OrderSellItemWidget(
                  orderbookItem: sellItems[index],
                  percentageFilled:
                      cumulativeAmount[index] / cumulativeAmount.first,
                  marketDropDownNotifier: marketDropDownNotifier,
                  priceLengthNotifier: priceLengthNotifier,
                )),
      ),
    );
  }

  Widget _buildBuyWidget(List<OrderbookItemEntity> buyItems) {
    List<double> cumulativeAmount = _buildCumulativeAmountList(items: buyItems);

    return Padding(
      padding: EdgeInsets.only(left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
            buyItems.length,
            (index) => OrderBuyItemWidget(
                  orderbookItem: buyItems[index],
                  percentageFilled:
                      cumulativeAmount[index] / cumulativeAmount.last,
                  marketDropDownNotifier: marketDropDownNotifier,
                  priceLengthNotifier: priceLengthNotifier,
                )),
      ),
    );
  }

  List<double> _buildCumulativeAmountList({
    required List<OrderbookItemEntity> items,
    bool isAscendingOrder = true,
  }) {
    final List<double> cumulativeAmount = [];

    if (isAscendingOrder) {
      for (var i = 0; i < items.length; i++) {
        if (i == 0) {
          cumulativeAmount.add((items[i].amount * items[i].price));
        } else {
          cumulativeAmount
              .add(cumulativeAmount.last + (items[i].amount * items[i].price));
        }
      }

      return cumulativeAmount;
    } else {
      for (var i = items.length - 1; i >= 0; i--) {
        if (i == items.length - 1) {
          cumulativeAmount.add((items[i].amount * items[i].price));
        } else {
          cumulativeAmount
              .add(cumulativeAmount.last + (items[i].amount * items[i].price));
        }
      }

      return cumulativeAmount.reversed.toList();
    }
  }

  Widget _buildHeadingWidget() {
    final String amountColumnTitle =
        marketDropDownNotifier.value == EnumMarketDropdownTypes.depthmarket
            ? 'Cum'
            : 'Amount';

    return Padding(
      padding: EdgeInsets.only(
        left: 8,
        top: 16,
        bottom: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Price (${priceToken.symbol})',
              style: tsS13W500CFFOP40,
            ),
          ),
          Text(
            '$amountColumnTitle (${amountToken.symbol})',
            style: tsS13W500CFFOP40,
            textAlign: TextAlign.end,
          )
        ],
      ),
    );
  }

  Widget _buildLatestTransactionShimmerWidget({bool isDownTendency = true}) {
    return Shimmer.fromColors(
      highlightColor: AppColors.color8BA1BE,
      baseColor: AppColors.color2E303C,
      child: Padding(
        padding: EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 8,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLatestTransactionWidget() {
    return BlocBuilder<RecentTradesCubit, RecentTradesState>(
      builder: (context, state) {
        if (state is RecentTradesLoaded) {
          final isUpTendency = state.trades.length >= 2
              ? state.trades.first.price >= state.trades[1].price
              : true;

          return Padding(
            padding: EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 8,
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
                        isUpTendency
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: isUpTendency
                            ? AppColors.color0CA564
                            : AppColors.colorE6007A,
                        size: 18,
                      ),
                      Text(
                        state.trades.isEmpty
                            ? ''
                            : state.trades.first.price.toStringAsFixed(4),
                        style:
                            isUpTendency ? tsS18W600C0CA564 : tsS18W600CE6007A,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is RecentTradesError) {
          return PolkadexErrorRefreshWidget(
            onRefresh: () => context.read<RecentTradesCubit>().getRecentTrades(
                  context.read<MarketAssetCubit>().currentMarketId,
                ),
          );
        } else {
          return _buildLatestTransactionShimmerWidget();
        }
      },
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
