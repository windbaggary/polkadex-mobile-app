import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/orderbook/presentation/cubit/orderbook_cubit.dart';
import 'package:polkadex/common/trades/presentation/cubits/order_history_cubit/order_history_cubit.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';
import 'package:polkadex/features/landing/presentation/cubits/ticker_cubit/ticker_cubit.dart';
import 'package:polkadex/features/landing/presentation/providers/home_scroll_notif_provider.dart';
import 'package:polkadex/features/landing/presentation/cubits/place_order_cubit/place_order_cubit.dart';
import 'package:polkadex/features/landing/presentation/widgets/trade_bottom_widget.dart';
import 'package:polkadex/features/landing/presentation/widgets/place_order_widget.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:polkadex/common/orderbook/presentation/widgets/order_book_widget.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/injection_container.dart';

import 'package:provider/provider.dart';

/// The tab view of trade for Homescreen
///
/// XD_PAGE: 7
class TradeTabView extends StatefulWidget {
  @override
  _TradeTabViewState createState() => _TradeTabViewState();
}

class _TradeTabViewState extends State<TradeTabView>
    with TickerProviderStateMixin {
  late TabController _buySellDotController;
  late ScrollController _scrollController;

  @override
  void initState() {
    _buySellDotController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController()..addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    _disposeControllers();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  /// Method to dispose the controller and set to null to avoid verify later
  void _disposeControllers() {
    _buySellDotController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MarketAssetCubit>();

    return _ThisInheritedWidget(
      buySellTabController: _buySellDotController,
      child: ChangeNotifierProvider<OrderBookWidgetFilterProvider>(
        create: (context) => OrderBookWidgetFilterProvider(),
        builder: (context, _) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<PlaceOrderCubit>(
                create: (_) => dependency<PlaceOrderCubit>(),
              ),
              BlocProvider<OrderHistoryCubit>(
                create: (_) => dependency<OrderHistoryCubit>()
                  ..getOrders(
                    cubit.currentBaseAssetDetails.assetId,
                    context.read<AccountCubit>().proxyAccountAddress,
                    true,
                  ),
              ),
            ],
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 64),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocBuilder<MarketAssetCubit, MarketAssetState>(
                      builder: (context, marketAssetState) =>
                          BlocBuilder<TickerCubit, TickerState>(
                            builder: (context, tickerState) {
                              return _ThisTopRowSelectWidget(
                                ticker: tickerState is TickerLoaded
                                    ? tickerState.ticker[cubit.currentMarketId]
                                    : null,
                              );
                            },
                          )),
                  Container(
                    color: AppColors.color2E303C,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    margin: EdgeInsets.only(top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child:
                              BlocBuilder<MarketAssetCubit, MarketAssetState>(
                            builder: (context, state) => OrderBookWidget(
                              amountToken: cubit.currentBaseAssetDetails,
                              priceToken: cubit.currentQuoteAssetDetails,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: PlaceOrderWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TradeBottomWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _scrollListener() {
    context.read<HomeScrollNotifProvider>().scrollOffset =
        _scrollController.offset;
  }
}

/// The top widget of the screen
/// The widget include the selection and percentage
class _ThisTopRowSelectWidget extends StatelessWidget {
  _ThisTopRowSelectWidget({required this.ticker});

  final TickerEntity? ticker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        top: 8,
        right: 8,
      ),
      child: BlocBuilder<MarketAssetCubit, MarketAssetState>(
        builder: (context, state) => Row(
          children: [
            Expanded(
                child: _ThisTopSelectableWidget(
                    graphColor: mainTrendColor(),
                    onTap: () => _onMarketSelection(context))),
            Container(
              decoration: BoxDecoration(
                color: mainTrendColor().withOpacity(0.3),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                top: 2,
                right: 4,
                bottom: 2,
              ),
              child: Row(
                children: [
                  Icon(
                    isPriceTrendDown()
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up,
                    color: mainTrendColor(),
                    size: 18,
                  ),
                  Text(
                    "${ticker?.priceChangePercent24Hr.toStringAsFixed(2)}%",
                    style: tsS14W600CFF.copyWith(color: mainTrendColor()),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isPriceTrendDown() => (ticker?.priceChangePercent24Hr ?? 0.0) < 0;

  Color mainTrendColor() =>
      isPriceTrendDown() ? AppColors.colorE6007A : AppColors.color0CA564;

  void _onMarketSelection(BuildContext context) {
    Coordinator.goToMarketTokenSelectionScreen(
            orderbookCubit: context.read<OrderbookCubit>())
        .then(
      (model) {
        if (model != null) {
          context.read<MarketAssetCubit>().changeSelectedMarket(
              model.selectedBaseAsset, model.selectedQuoteAsset);
        }
      },
    );
  }
}

/// The widget to handle the ontap for picker
///
class _ThisTopSelectableWidget extends StatelessWidget {
  const _ThisTopSelectableWidget({
    required this.graphColor,
    this.onTap,
  });

  final VoidCallback? onTap;
  final Color graphColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            BlocBuilder<MarketAssetCubit, MarketAssetState>(
              builder: (context, state) => Container(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    TokenUtils.tokenIdToAssetSvg(context
                        .read<MarketAssetCubit>()
                        .currentBaseAssetDetails
                        .assetId),
                    width: 48,
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: BlocBuilder<MarketAssetCubit, MarketAssetState>(
                    builder: (context, state) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${context.read<MarketAssetCubit>().currentBaseAssetDetails.symbol}/${context.read<MarketAssetCubit>().currentQuoteAssetDetails.symbol}',
                          style: tsS20W600CFF,
                        ),
                        Text(
                          context
                              .read<MarketAssetCubit>()
                              .currentBaseAssetDetails
                              .name,
                          style: tsS14W400CFF.copyWith(
                              color: AppColors.colorABB2BC),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.color3B4150),
                    color: AppColors.color2E303C,
                  ),
                  padding: EdgeInsets.all(4),
                  margin: EdgeInsets.only(left: 4, right: 8),
                  child: SvgPicture.asset(
                    'switch'.asAssetSvg(),
                    width: 12,
                    height: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 80, maxHeight: 30),
                child: Sparkline(
                  data: [-1.5, 1 - 0, 2 - 5, -1.5, 2, 5, -2.3],
                  lineColor: graphColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The inherited widget for the screen
class _ThisInheritedWidget extends InheritedWidget {
  final TabController buySellTabController;

  _ThisInheritedWidget({
    required this.buySellTabController,
    required Widget child,
  }) : super(
          child: child,
        );

  @override
  bool updateShouldNotify(covariant _ThisInheritedWidget oldWidget) {
    return oldWidget.buySellTabController != buySellTabController;
  }
}
