import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/dummy_providers/balance_chart_dummy_provider.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/features/coin/presentation/cubits/trade_history_cubit/trade_history_cubit.dart';
import 'package:polkadex/features/landing/presentation/providers/home_scroll_notif_provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:polkadex/common/widgets/chart/_app_line_chart_widget.dart';
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
                      InkWell(
                        onTap: () {
                          final summaryVisProvider =
                              context.read<_ThisIsChartVisibleProvider>();

                          summaryVisProvider.isChartVisible
                              ? _controller.reverse()
                              : _controller.forward();

                          summaryVisProvider.toggleVisible();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            children: [
                              Text(
                                'Summary of Trades',
                                style: tsS18W600CFF,
                                textAlign: TextAlign.center,
                              ),
                              RotationTransition(
                                turns: Tween(begin: 0.0, end: 0.5)
                                    .animate(_controller),
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.colorFFFFFF,
                                  size: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Consumer<_ThisIsChartVisibleProvider>(
                        builder: (context, isChartVisbileProvider, _) =>
                            AnimatedSize(
                          duration: AppConfigs.animDurationSmall,
                          alignment: Alignment.topCenter,
                          child: isChartVisbileProvider.isChartVisible
                              ? Column(
                                  children: [
                                    _ThisGraphHeadingWidget(),
                                    SizedBox(height: 8),
                                    SizedBox(
                                      height: 250,
                                      child:
                                          Consumer<BalanceChartDummyProvider>(
                                        builder: (context, provider, child) =>
                                            AppLineChartWidget(
                                          data: provider.list,
                                          options: AppLineChartOptions(
                                            yLabelCount: 3,
                                            yAxisTopPaddingRatio: 0.05,
                                            yAxisBottomPaddingRatio: 0.15,
                                            chartScale: provider.chartScale,
                                            lineColor: AppColors.colorE6007A,
                                            yAxisLabelPrefix: "\$ ",
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
                                    SizedBox(height: 30),
                                  ],
                                )
                              : Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: Container(
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
              child: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    floating: false,
                    pinned: true,
                    delegate: _SliverPersistentHeaderDelegate(
                      height: 115,
                      child: Container(
                        color: AppColors.color2E303C,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 13),
                                decoration: BoxDecoration(
                                  color: AppColors.color1C2023,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 3,
                                width: 51,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
                      selectedAsset,
                      context.read<AccountCubit>().mainAccountAddress,
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
}

/// The heading part of the graph.
class _ThisGraphHeadingWidget extends StatelessWidget {
  Widget _buildItemWidget(
      {required String? imgAsset,
      required String title,
      required String value}) {
    return Row(
      children: [
        Container(
          width: 23,
          height: 23,
          decoration: BoxDecoration(
            color: (imgAsset == null)
                ? AppColors.color8BA1BE.withOpacity(0.20)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.only(right: 6),
          padding: const EdgeInsets.all(2),
          child: (imgAsset == null) ? null : Image.asset(imgAsset),
        ),
        Expanded(
            child: Text(
          title,
          style: tsS13W500CFF.copyWith(color: AppColors.colorABB2BC),
        )),
        Text(
          value,
          style: tsS12W500CFF,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(21, 0, 21, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 5,
                            child: _buildItemWidget(
                                imgAsset:
                                    'trade_open/trade_open_1.png'.asAssetImg(),
                                title: 'BTC',
                                value: "60%")),
                        Spacer(),
                        Expanded(
                            flex: 5,
                            child: _buildItemWidget(
                                imgAsset:
                                    'trade_open/trade_open_2.png'.asAssetImg(),
                                title: 'DEX',
                                value: "22%")),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        Expanded(
                            flex: 5,
                            child: _buildItemWidget(
                                imgAsset:
                                    'trade_open/trade_open_3.png'.asAssetImg(),
                                title: 'USDT',
                                value: "10%")),
                        Spacer(),
                        Expanded(
                            flex: 5,
                            child: _buildItemWidget(
                                imgAsset: null, title: 'Others', value: "8%")),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Coordinator.goToBalanceSummaryScreen(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.colorE6007A,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset('pie-chart-18'.asAssetSvg()),
                ),
              ),
            ],
          ),
        ],
      ),
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

/// The bottom option menu unnder the graph
class _ThisGraphOptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 16, 14),
      child: Wrap(
        children: EnumBalanceChartDataTypes.values
            .map<Widget>((item) => Consumer<BalanceChartDummyProvider>(
                  builder: (context, appChartProvider, child) {
                    String text;
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

/// The sliver widget to maintain the wallet heading persistent on scroll
class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverPersistentHeaderDelegate({
    required this.child,
    required this.height,
  }) : super();
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
