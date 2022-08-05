import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/common/dummy_providers/balance_chart_dummy_provider.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/features/coin/presentation/cubits/trade_history_cubit/trade_history_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/presentation/providers/home_scroll_notif_provider.dart';
import 'package:polkadex/features/coin/presentation/widgets/order_history_shimmer_widget.dart';
import 'package:polkadex/features/landing/presentation/widgets/trade_item_widget.dart';
import 'package:polkadex/common/widgets/custom_date_range_picker.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:polkadex/common/widgets/polkadex_progress_error_widget.dart';

import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:provider/provider.dart';

/// XD_PAGE: 18
/// XD_PAGE: 19
class BalanceTabView extends StatefulWidget {
  @override
  _BalanceTabViewState createState() => _BalanceTabViewState();
}

class _BalanceTabViewState extends State<BalanceTabView>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _controller;
  final List<Enum> _typeFilters = [];
  DateTimeRange? _dateRange;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScrollListener);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollListener);
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<_ThisIsChartVisibleProvider>(
            create: (_) => _ThisIsChartVisibleProvider()),
        ChangeNotifierProvider<BalanceChartDummyProvider>(
          create: (_) => BalanceChartDummyProvider(),
        ),
      ],
      builder: (context, _) =>
          BlocBuilder<TradeHistoryCubit, TradeHistoryState>(
        builder: (context, state) {
          return NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSelectTokenWidget(assetEntity: state.assetSelected),
                      _buildBalanceWidget(),
                      SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          final summaryVisProvider =
                              context.read<_ThisIsChartVisibleProvider>();

                          summaryVisProvider.isChartVisible
                              ? _controller.reverse()
                              : _controller.forward();

                          summaryVisProvider.toggleVisible();
                        },
                        child: state.assetSelected != null
                            ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Trades',
                                      style: tsS18W600CFF,
                                      textAlign: TextAlign.center,
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6),
                                          child: InkWell(
                                            onTap: () =>
                                                _onBuyFilterButtonPress(
                                                    context),
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 7.0,
                                                      horizontal: 9),
                                              decoration: BoxDecoration(
                                                  color: _typeFilters.contains(
                                                          EnumBuySell.buy)
                                                      ? Colors.white
                                                      : AppColors.color8BA1BE
                                                          .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
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
                                                _onSellFilterButtonPress(
                                                    context),
                                            child: Container(
                                              width: 36,
                                              height: 36,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 7.0,
                                                      horizontal: 9),
                                              decoration: BoxDecoration(
                                                  color: _typeFilters.contains(
                                                          EnumBuySell.sell)
                                                      ? Colors.white
                                                      : AppColors.color8BA1BE
                                                          .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
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
                                              primaryColor: AppColors
                                                  .color1C2023,
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
                                  ],
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: state.assetSelected != null
                ? _buildTradeList(asset: state.assetSelected!)
                : Container(),
          );
        },
      ),
    );
  }

  Widget _buildTradeList({required AssetEntity asset}) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: AppColors.color2E303C,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: Offset(0.0, 20.0),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(12.5, 19.0, 12.5, 0.0),
          child: BlocBuilder<TradeHistoryCubit, TradeHistoryState>(
            builder: (context, state) {
              if (state is TradeHistoryLoaded) {
                return state.trades.isEmpty
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(18, 26.0, 18, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 36, bottom: 36),
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
                          return TradeItemWidget(
                            tradeItem: state.trades[index],
                            dateTitle: _getDateTitle(
                                state.trades[index].time,
                                index > 0
                                    ? state.trades[index - 1].time
                                    : null),
                          );
                        },
                      );
              }

              if (state is TradeHistoryError) {
                return Container(
                  height: 50,
                  child: PolkadexErrorRefreshWidget(
                    onRefresh: () =>
                        context.read<TradeHistoryCubit>().getAccountTrades(
                              asset: asset,
                              address: context
                                  .read<AccountCubit>()
                                  .mainAccountAddress,
                            ),
                  ),
                );
              }

              return OrderHistoryShimmerWidget();
            },
          ),
        );
      },
    );
  }

  String? _getDateTitle(DateTime date, DateTime? previousDate) {
    final dateString = _getDateString(date);
    final datePreviousString =
        previousDate != null ? _getDateString(previousDate) : '';

    return dateString != datePreviousString ? dateString : null;
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

  void _onScrollListener() {
    context.read<HomeScrollNotifProvider>().scrollOffset =
        _scrollController.offset;
  }

  Widget _buildSelectTokenWidget({required AssetEntity? assetEntity}) {
    final availableAssets = context.read<MarketAssetCubit>().mapAvailableAssets;

    return Padding(
      padding: EdgeInsets.all(6),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          padding: EdgeInsets.all(8),
          child: DropdownButton<AssetEntity>(
            items: availableAssets.values
                .map(
                  (asset) => DropdownMenuItem<AssetEntity>(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Image.asset(
                            TokenUtils.tokenIdToAssetImg(asset.assetId),
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 8),
                          Text('${asset.name} (${asset.symbol})'),
                        ],
                      ),
                    ),
                    value: asset,
                  ),
                )
                .toList(),
            value: assetEntity,
            dropdownColor: Colors.white,
            underline: Container(),
            style: tsS20W600CFF.copyWith(color: Colors.black),
            hint: Text('Select an asset'),
            onChanged: (selectedAsset) {
              if (selectedAsset != null) {
                context.read<TradeHistoryCubit>().getAccountTrades(
                      asset: selectedAsset,
                      address: context.read<AccountCubit>().mainAccountAddress,
                    );
              }
            },
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.black,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceWidget() {
    final selectedAsset = context.read<TradeHistoryCubit>().state.assetSelected;

    return BlocBuilder<BalanceCubit, BalanceState>(
      builder: (context, state) =>
          state is BalanceLoaded && selectedAsset != null
              ? Padding(
                  padding: EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Free: ${state.free[selectedAsset.assetId]}',
                              style: tsS16W600CFF,
                            ),
                            Text(
                              'Reserved: ${state.reserved[selectedAsset.assetId]}',
                              style: tsS16W600CFF,
                            ),
                          ],
                        ),
                      ),
                      AppButton(
                        label: 'Withdraw',
                        leadingWidget: SvgPicture.asset(
                          'Withdraw'.asAssetSvg(),
                        ),
                        backgroundColor: AppColors.color3B4150,
                        onTap: () => Coordinator.goToCoinWithdrawScreen(
                          asset: selectedAsset,
                          balanceCubit: context.read<BalanceCubit>(),
                        ),
                        outerPadding: EdgeInsets.only(top: 8),
                      ),
                    ],
                  ),
                )
              : Container(),
    );
  }
}

/// The provider to maintain the hide and visible of charts
class _ThisIsChartVisibleProvider extends ChangeNotifier {
  bool _isChartVisible = false;

  bool get isChartVisible => _isChartVisible;

  set isChartVisible(bool value) {
    _isChartVisible = value;
    notifyListeners();
  }

  void toggleVisible() {
    _isChartVisible = !_isChartVisible;
    notifyListeners();
  }
}
