import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/dummy_providers/balance_chart_dummy_provider.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/orderbook/presentation/cubit/orderbook_cubit.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/trades/domain/entities/trade_entity.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/common/widgets/chart/_app_line_chart_widget.dart';
import 'package:polkadex/common/widgets/custom_app_bar.dart';
import 'package:polkadex/common/widgets/custom_date_range_picker.dart';
import 'package:polkadex/features/coin/presentation/widgets/order_history_shimmer_widget.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/coin/presentation/cubits/trade_history_cubit/trade_history_cubit.dart';
import 'package:polkadex/features/landing/presentation/widgets/top_pair_widget.dart';
import 'package:polkadex/common/widgets/polkadex_progress_error_widget.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:polkadex/injection_container.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:shimmer/shimmer.dart';

/// The screen enum menus only accessing inside this file.
/// The enum represent the first top 3 menu of the screen
///
enum _EnumMenus {
  deposit,
  withdraw,
  trade,
}

/// XD_PAGE: 20
/// XD_PAGE: 31
class BalanceCoinScreen extends StatefulWidget {
  BalanceCoinScreen({required this.asset});

  final AssetEntity asset;

  @override
  _BalanceCoinPreviewScreenState createState() =>
      _BalanceCoinPreviewScreenState();
}

class _BalanceCoinPreviewScreenState extends State<BalanceCoinScreen>
    with TickerProviderStateMixin {
  final _isShowGraphNotifier = ValueNotifier<bool>(false);
  final List<Enum> _typeFilters = [];
  DateTimeRange? _dateRange;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => dependency<TradeHistoryCubit>()
        ..getTrades(
          widget.asset.assetId,
          context.read<AccountCubit>().mainAccountAddress,
        ),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<BalanceChartDummyProvider>(
            create: (_) => BalanceChartDummyProvider(),
          ),
        ],
        builder: (context, _) => Scaffold(
          backgroundColor: AppColors.color1C2023,
          body: SafeArea(
            child: CustomAppBar(
              title: '${widget.asset.name} (${widget.asset.symbol})',
              titleStyle: tsS19W700CFF,
              onTapBack: () => Navigator.of(context).pop(),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.color1C2023,
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(40)),
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 30, bottom: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InkWell(
                          onTap: () {
                            _isShowGraphNotifier.value =
                                !_isShowGraphNotifier.value;
                          },
                          child: _TopCoinTitleWidget(
                            tokenId: widget.asset.assetId,
                          )),
                      ValueListenableBuilder<bool>(
                        valueListenable: _isShowGraphNotifier,
                        builder: (context, isShowGraph, child) {
                          Widget child = Container();
                          if (isShowGraph) {
                            child = Column(
                              children: [
                                SizedBox(height: 8),
                                SizedBox(
                                  height: 250,
                                  child: Consumer<BalanceChartDummyProvider>(
                                    builder: (context, provider, child) =>
                                        AppLineChartWidget(
                                      data: provider.list,
                                      options: AppLineChartOptions(
                                        yLabelCount: 3,
                                        yAxisTopPaddingRatio: 0.05,
                                        yAxisBottomPaddingRatio: 0.00,
                                        chartScale: provider.chartScale,
                                        lineColor: AppColors.colorE6007A,
                                        yAxisLabelPrefix: "",
                                        areaGradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: <Color>[
                                            AppColors.colorE6007A
                                                .withOpacity(0.50),
                                            AppColors.color8BA1BE
                                                .withOpacity(0.0),
                                          ],
                                          // stops: [0.0, 0.40],
                                        ),
                                        gridColor: AppColors.color8BA1BE
                                            .withOpacity(0.15),
                                        gridStroke: 1,
                                        yLabelTextStyle: TextStyle(
                                          fontSize: 08,
                                          fontFamily: "WorkSans",
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                _ThisGraphOptionWidget(),
                                // SizedBox(height: 0),
                              ],
                            );
                          }
                          return AnimatedSize(
                            duration: AppConfigs.animDurationSmall,
                            child: child,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(21, 42, 21, 0.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: buildInkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () =>
                                    Coordinator.goToBalanceDepositScreenOne(
                                        tokenId: widget.asset.assetId,
                                        balanceCubit:
                                            context.read<BalanceCubit>()),
                                child: _ThisMenuItemWidget(
                                  menu: _EnumMenus.deposit,
                                ),
                              ),
                            ),
                            SizedBox(
                                width: math.min(16.0,
                                    MediaQuery.of(context).size.width * 0.025)),
                            Expanded(
                              child: buildInkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => Coordinator.goToCoinWithdrawScreen(
                                    tokenId: widget.asset.assetId,
                                    balanceCubit: context.read<BalanceCubit>()),
                                child: _ThisMenuItemWidget(
                                  menu: _EnumMenus.withdraw,
                                ),
                              ),
                            ),
                            SizedBox(
                                width: math.min(16.0,
                                    MediaQuery.of(context).size.width * 0.025)),
                            Expanded(
                              child: buildInkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => Coordinator.goToCoinTradeScreen(
                                    orderbookCubit:
                                        context.read<OrderbookCubit>(),
                                    balanceCubit: context.read<BalanceCubit>(),
                                    baseToken: widget.asset,
                                    quoteToken: context
                                        .read<MarketAssetCubit>()
                                        .listAvailableMarkets
                                        .firstWhere((market) =>
                                            market[0].assetId ==
                                            widget.asset.assetId)[1]),
                                child: _ThisMenuItemWidget(
                                  menu: _EnumMenus.trade,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 21, bottom: 12, top: 42),
                        child: Text(
                          "Trade Pairs",
                          style: tsS20W600CFF,
                        ),
                      ),
                      SizedBox(
                        height: 108,
                        child: ListView.builder(
                          itemBuilder: (context, index) => TopPairWidget(
                            leftAsset: context
                                .read<MarketAssetCubit>()
                                .listAvailableMarkets[index][0],
                            rightAsset: context
                                .read<MarketAssetCubit>()
                                .listAvailableMarkets[index][1],
                            onTap: () => Coordinator.goToCoinTradeScreen(
                                orderbookCubit: context.read<OrderbookCubit>(),
                                baseToken: context
                                    .read<MarketAssetCubit>()
                                    .listAvailableMarkets[index][0],
                                quoteToken: context
                                    .read<MarketAssetCubit>()
                                    .listAvailableMarkets[index][1],
                                balanceCubit: context.read<BalanceCubit>()),
                          ),
                          itemCount: context
                              .read<MarketAssetCubit>()
                              .listAvailableMarkets
                              .length,
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(left: 21),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(21, 52, 21, 20.0),
                        child: Row(
                          children: [
                            Text(
                              "History",
                              style: tsS20W600CFF,
                            ),
                            Spacer(),
                            BlocBuilder<TradeHistoryCubit, TradeHistoryState>(
                              builder: (context, state) => Opacity(
                                opacity:
                                    state is! TradeHistoryLoaded ? 0.3 : 1.0,
                                child: IgnorePointer(
                                  ignoring: state is! TradeHistoryLoaded,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 6),
                                        child: InkWell(
                                          onTap: () =>
                                              _onBuyFilterButtonPress(context),
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7.0, horizontal: 9),
                                            decoration: BoxDecoration(
                                                color: _typeFilters.contains(
                                                        EnumBuySell.buy)
                                                    ? Colors.white
                                                    : AppColors.color8BA1BE
                                                        .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: SvgPicture.asset(
                                              (_typeFilters.contains(
                                                          EnumBuySell.buy)
                                                      ? 'buysel'
                                                      : 'buy')
                                                  .asAssetSvg(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 6),
                                        child: InkWell(
                                          onTap: () =>
                                              _onSellFilterButtonPress(context),
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7.0, horizontal: 9),
                                            decoration: BoxDecoration(
                                                color: _typeFilters.contains(
                                                        EnumBuySell.sell)
                                                    ? Colors.white
                                                    : AppColors.color8BA1BE
                                                        .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: SvgPicture.asset(
                                              (_typeFilters.contains(
                                                          EnumBuySell.sell)
                                                      ? 'sellsel'
                                                      : 'sell')
                                                  .asAssetSvg(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 14),
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                            primaryColor: AppColors.color1C2023,
                                            cardColor: Colors.red,
                                            colorScheme:
                                                ColorScheme.fromSwatch()
                                                    .copyWith(
                                                        secondary: AppColors
                                                            .colorE6007A),
                                            buttonTheme: ButtonThemeData(
                                                highlightColor: Colors.green,
                                                buttonColor: Colors.green,
                                                textTheme:
                                                    ButtonTextTheme.accent)),
                                        child: Builder(
                                          builder: (context) => InkWell(
                                            onTap: () async =>
                                                _onDateFilterButtonPress(
                                                    context),
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 7.0,
                                                      horizontal: 9),
                                              decoration: BoxDecoration(
                                                  color: _dateRange != null
                                                      ? AppColors.colorE6007A
                                                      : AppColors.color8BA1BE
                                                          .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: SvgPicture.asset(
                                                'calendar'.asAssetSvg(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.color2E303C,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: <BoxShadow>[bsDefault],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child:
                            BlocBuilder<TradeHistoryCubit, TradeHistoryState>(
                          builder: (context, state) {
                            if (state is TradeHistoryLoaded) {
                              return state.trades.isEmpty
                                  ? Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(18, 26.0, 18, 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 36, bottom: 36),
                                            child: Text(
                                              "There are no transactions",
                                              style: tsS16W500CABB2BC,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: state.trades.length,
                                      padding: const EdgeInsets.only(top: 13),
                                      itemBuilder: (context, index) {
                                        return _ThisItemWidget(
                                          tradeItem: state.trades[index],
                                          dateTitle: _getDateTitle(
                                              state.trades[index].timestamp,
                                              index > 0
                                                  ? state.trades[index - 1]
                                                      .timestamp
                                                  : null),
                                        );
                                      },
                                    );
                            }

                            if (state is TradeHistoryError) {
                              return Container(
                                height: 50,
                                child: PolkadexErrorRefreshWidget(
                                  onRefresh: () => context
                                      .read<TradeHistoryCubit>()
                                      .getTrades(
                                        widget.asset.assetId,
                                        context
                                            .read<AccountCubit>()
                                            .mainAccountAddress,
                                      ),
                                ),
                              );
                            }

                            return OrderHistoryShimmerWidget();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onBuyFilterButtonPress(BuildContext context) {
    setState(() => _typeFilters.contains(EnumBuySell.buy)
        ? _typeFilters.remove(EnumBuySell.buy)
        : _typeFilters.add(EnumBuySell.buy));

    context.read<TradeHistoryCubit>().updateTradeHistoryFilter(
          filters: _typeFilters,
          dateFilter: _dateRange,
        );
  }

  void _onSellFilterButtonPress(BuildContext context) {
    setState(() => _typeFilters.contains(EnumBuySell.sell)
        ? _typeFilters.remove(EnumBuySell.sell)
        : _typeFilters.add(EnumBuySell.sell));

    context.read<TradeHistoryCubit>().updateTradeHistoryFilter(
          filters: _typeFilters,
          dateFilter: _dateRange,
        );
  }

  Future<void> _onDateFilterButtonPress(BuildContext context) async {
    final _tempDate = await CustomDateRangePicker.call(
        filterStartDate: _dateRange?.start,
        filterEndDate: _dateRange?.end,
        context: context);
    setState(() => _dateRange = _tempDate);

    context.read<TradeHistoryCubit>().updateTradeHistoryFilter(
          filters: _typeFilters,
          dateFilter: _dateRange,
        );
  }

  String _getDateString(DateTime date) {
    final today = DateTime.now();
    if (date.day == today.day &&
        date.month == today.month &&
        date.year == today.year) {
      return "Today";
    } else if (date.day == today.day - 1 &&
        date.month == today.month &&
        date.year == today.year) {
      return "Yesterday";
    } else {
      return DateFormat("dd MMMM, yyyy").format(date);
    }
  }

  String? _getDateTitle(DateTime date, DateTime? previousDate) {
    final dateString = _getDateString(date);
    final datePreviousString =
        previousDate != null ? _getDateString(previousDate) : '';

    return dateString != datePreviousString ? dateString : null;
  }
}

/// The base class for the list item
class _ThisItemWidget extends StatelessWidget {
  final TradeEntity tradeItem;
  final String? dateTitle;

  const _ThisItemWidget({
    required this.tradeItem,
    required this.dateTitle,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    if (tradeItem is OrderEntity) {
      switch (tradeItem.event) {
        case EnumTradeTypes.bid:
        case EnumTradeTypes.ask:
          child =
              _buildHistoryOrderItemWidget(context, tradeItem as OrderEntity);
          break;
        default:
          child = Container();
      }
    } else {
      switch (tradeItem.event) {
        case EnumTradeTypes.deposit:
        case EnumTradeTypes.withdraw:
          child = _buildHistoryTradeItemWidget(context, tradeItem);
          break;
        default:
          child = Container();
      }
    }

    final cardWidget = Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.fromLTRB(14, 17, 14, 17),
        child: child,
      ),
    );

    if (dateTitle?.isNotEmpty ?? false) {
      final double topPadding =
          ['Today', 'Yesterday'].contains(dateTitle) ? 7.0 : 26.0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18, topPadding, 18, 10),
            child: Text(
              dateTitle ?? "",
              style: tsS16W500CFF,
            ),
          ),
          cardWidget,
        ],
      );
    }

    return cardWidget;
  }

  Widget _buildHistoryTradeItemWidget(BuildContext context, TradeEntity trade) {
    final cubit = context.read<MarketAssetCubit>();
    Widget mainIcon;

    switch (trade.event) {
      case EnumTradeTypes.deposit:
        mainIcon = SvgPicture.asset(
          'Deposit'.asAssetSvg(),
        );
        break;
      case EnumTradeTypes.withdraw:
        mainIcon = SvgPicture.asset(
          'Withdraw'.asAssetSvg(),
        );
        break;
      default:
        mainIcon = Container();
    }

    return Row(
      children: [
        Container(
          width: 47,
          height: 47,
          margin: const EdgeInsets.only(right: 4.2),
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 13),
          decoration: BoxDecoration(
              color: AppColors.color8BA1BE.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12)),
          child: mainIcon,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                cubit.getAssetDetailsById(trade.baseAsset).symbol,
                style: tsS15W500CFF,
              ),
              SizedBox(height: 1),
              Text(
                DateFormat("hh:mm:ss aa").format(trade.timestamp).toUpperCase(),
                style: tsS13W400CFFOP60.copyWith(color: AppColors.colorABB2BC),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  '${trade.amount} ${cubit.getAssetDetailsById(trade.baseAsset).symbol}',
                  style: tsS14W500CFF.copyWith(
                    color: trade.event == EnumTradeTypes.bid ||
                            trade.event == EnumTradeTypes.deposit
                        ? AppColors.color0CA564
                        : AppColors.colorE6007A,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHistoryOrderItemWidget(BuildContext context, OrderEntity order) {
    final cubit = context.read<MarketAssetCubit>();
    Widget mainIcon, arrowIcon;

    switch (order.event) {
      case EnumTradeTypes.bid:
        mainIcon = SvgPicture.asset(
          'buy'.asAssetSvg(),
        );
        break;
      case EnumTradeTypes.ask:
        mainIcon = SvgPicture.asset(
          'sell'.asAssetSvg(),
        );
        break;
      default:
        mainIcon = Container();
    }

    switch (order.event) {
      case EnumTradeTypes.bid:
        arrowIcon = SvgPicture.asset(
          'Arrow-Green'.asAssetSvg(),
          width: 10,
          height: 6.0,
        );
        break;
      case EnumTradeTypes.ask:
        arrowIcon = SvgPicture.asset(
          'Arrow-Red'.asAssetSvg(),
          width: 10,
          height: 6.0,
        );
        break;
      default:
        arrowIcon = Container();
    }

    return Row(
      children: [
        Container(
          width: 47,
          height: 47,
          margin: const EdgeInsets.only(right: 4.2),
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 13),
          decoration: BoxDecoration(
              color: AppColors.color8BA1BE.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12)),
          child: mainIcon,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${cubit.getAssetDetailsById(order.baseAsset).symbol}/${cubit.getAssetDetailsById(order.quoteAsset).symbol}',
                style: tsS15W500CFF,
              ),
              SizedBox(height: 1),
              Text(
                DateFormat("hh:mm:ss aa").format(order.timestamp).toUpperCase(),
                style: tsS13W400CFFOP60.copyWith(color: AppColors.colorABB2BC),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  '${order.amount} ${cubit.getAssetDetailsById(order.baseAsset).symbol}',
                  style: tsS14W500CFF.copyWith(
                    color: order.event == EnumTradeTypes.bid ||
                            order.event == EnumTradeTypes.deposit
                        ? AppColors.color0CA564
                        : AppColors.colorE6007A,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 4.0,
                  ),
                  child: arrowIcon,
                ),
                Text(
                  '${double.parse(order.amount) * double.parse(order.price)} ${cubit.getAssetDetailsById(order.quoteAsset).symbol}',
                  style: tsS14W500CFF,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// The item widget for the top menu
/// [_EnumMenus] are represented in this widget
class _ThisMenuItemWidget extends StatelessWidget {
  const _ThisMenuItemWidget({
    required this.menu,
  });

  final _EnumMenus menu;

  @override
  Widget build(BuildContext context) {
    String text;
    String svgAssets;
    switch (menu) {
      case _EnumMenus.deposit:
        text = "Deposit";
        svgAssets = "Deposit".asAssetSvg();

        break;
      case _EnumMenus.withdraw:
        text = "Withdraw";
        svgAssets = "Withdraw".asAssetSvg();
        break;
      case _EnumMenus.trade:
        text = "Trade";
        svgAssets = "trade_selected".asAssetSvg();
        break;
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.color2E303C.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[bsDefault],
      ),
      padding: const EdgeInsets.fromLTRB(0, 17, 0.0, 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 47,
              height: 47,
              padding:
                  const EdgeInsets.symmetric(vertical: 9.0, horizontal: 12),
              decoration: BoxDecoration(
                  color: AppColors.color8BA1BE.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12)),
              child: SvgPicture.asset(
                svgAssets,
              ),
            ),
          ),
          SizedBox(height: 36),
          Text(text, style: tsS16W500CFF),
        ],
      ),
    );
  }
}

/// The very top top widget includes the icon, name, value, price, etc
class _TopCoinTitleWidget extends StatelessWidget {
  const _TopCoinTitleWidget({required this.tokenId});

  final String tokenId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceCubit, BalanceState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.colorFFFFFF,
              ),
              width: 52,
              height: 52,
              padding: const EdgeInsets.all(3),
              child: Image.asset(
                TokenUtils.tokenIdToAssetImg(tokenId),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 11),
            Expanded(
              child: state is BalanceLoaded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          double.parse(state.free.getBalance(tokenId))
                              .toStringAsFixed(2),
                          style: tsS25W500CFF,
                        ),
                        SizedBox(height: 1),
                        Row(
                          children: [
                            Text(
                              '~\$76.12',
                              style: tsS15W400CFF.copyWith(
                                  color: AppColors.colorABB2BC),
                            ),
                            SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.color0CA564,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 1.5,
                                horizontal: 3.5,
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'gain_graph'.asAssetSvg(),
                                    width: 8,
                                    height: 7,
                                    color: AppColors.colorFFFFFF,
                                  ),
                                  SizedBox(width: 2),
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "12.57",
                                          style: tsS13W600CFF,
                                        ),
                                        TextSpan(
                                          text: "%",
                                          style: tsS13W600CFF.copyWith(
                                              fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : _orderBalanceShimmerWidget(),
            ),
            if (state is BalanceLoaded)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$42.50',
                    style: tsS13W600CFF,
                  ),
                  SizedBox(height: 02),
                  Text(
                    'Market Price',
                    style: tsS13W500CFF.copyWith(color: AppColors.colorABB2BC),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _orderBalanceShimmerWidget() {
    return Shimmer.fromColors(
      highlightColor: AppColors.color8BA1BE,
      baseColor: AppColors.color2E303C,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '2.0000',
              style: tsS25W500CFF,
            ),
            SizedBox(height: 1),
            Row(
              children: [
                Text(
                  '~\$76.12',
                  style: tsS15W400CFF.copyWith(color: AppColors.colorABB2BC),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.color0CA564,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 1.5,
                    horizontal: 3.5,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'gain_graph'.asAssetSvg(),
                        width: 8,
                        height: 7,
                        color: AppColors.colorFFFFFF,
                      ),
                      SizedBox(width: 2),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "12.57",
                              style: tsS13W600CFF,
                            ),
                            TextSpan(
                              text: "%",
                              style: tsS13W600CFF.copyWith(fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The widget displays the options under the graph
class _ThisGraphOptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 16, 14),
      child: Wrap(
        children: EnumBalanceChartDataTypes.values
            .map<Widget>((item) => Consumer<BalanceChartDummyProvider>(
                  builder: (context, appChartProvider, child) {
                    String? text;
                    switch (item) {
                      case EnumBalanceChartDataTypes.hour:
                        text = "24h";
                        break;
                      case EnumBalanceChartDataTypes.week:
                        text = "7d";
                        break;
                      case EnumBalanceChartDataTypes.month:
                        text = "1m";
                        break;
                      case EnumBalanceChartDataTypes.threeMonth:
                        text = "3m";
                        break;
                      case EnumBalanceChartDataTypes.sixMonth:
                        text = "6m";
                        break;
                      case EnumBalanceChartDataTypes.year:
                        text = "1y";
                        break;
                      case EnumBalanceChartDataTypes.all:
                        text = "All";
                        break;
                    }
                    return InkWell(
                      onTap: () {
                        appChartProvider.balanceChartDataType = item;
                      },
                      child: AnimatedContainer(
                        duration: AppConfigs.animDurationSmall,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 11.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: item == appChartProvider.balanceChartDataType
                              ? AppColors.colorE6007A
                              : null,
                        ),
                        child: Text(
                          text,
                          style: item == appChartProvider.balanceChartDataType
                              ? tsS13W600CFF
                              : tsS12W400CFF.copyWith(
                                  color: AppColors.colorABB2BC),
                        ),
                      ),
                    );
                  },
                ))
            .toList(),
      ),
    );
  }
}
