import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/cubits/account_cubit.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/orders/presentation/cubits/order_history_cubit.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/features/landing/presentation/cubits/ticker_cubit/ticker_cubit.dart';
import 'package:polkadex/features/landing/presentation/providers/home_scroll_notif_provider.dart';
import 'package:polkadex/features/landing/presentation/providers/trade_tab_provider.dart';
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
    return _ThisInheritedWidget(
      buySellTabController: _buySellDotController,
      child: ChangeNotifierProvider<OrderBookWidgetFilterProvider>(
        create: (context) => OrderBookWidgetFilterProvider(),
        builder: (context, _) {
          _ThisInheritedWidget.of(context)
              ?.buySellTabController
              .animateTo(context.read<TradeTabViewProvider>().orderSideIndex);

          return MultiBlocProvider(
            providers: [
              BlocProvider<PlaceOrderCubit>(
                create: (_) => dependency<PlaceOrderCubit>(),
              ),
              BlocProvider<OrderHistoryCubit>(
                create: (_) => dependency<OrderHistoryCubit>()
                  ..getOrders(
                    context.read<TradeTabCoinProvider>().tokenCoin.baseTokenId,
                    context.read<AccountCubit>().accountAddress,
                    context.read<AccountCubit>().accountSignature,
                    true,
                  ),
              ),
              BlocProvider<TickerCubit>(
                create: (_) => dependency<TickerCubit>()
                  ..getLastTicker(
                    leftTokenId: context
                        .read<TradeTabCoinProvider>()
                        .tokenCoin
                        .baseTokenId,
                    rightTokenId: context
                        .read<TradeTabCoinProvider>()
                        .tokenCoin
                        .pairTokenId,
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
                  _ThisTopRowSelectWidget(),
                  Container(
                    color: AppColors.color2E303C,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    margin: EdgeInsets.only(top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Consumer<TradeTabCoinProvider>(
                            builder: (context, provider, _) => OrderBookWidget(
                              amountTokenId: provider.tokenCoin.baseTokenId,
                              priceTokenId: provider.tokenCoin.pairTokenId,
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        top: 8,
        right: 8,
      ),
      child: Consumer<TradeTabCoinProvider>(
        builder: (context, coinProvider, child) => Row(
          children: [
            Expanded(
                child: _ThisTopSelectableWidget(
                    graphColor: coinProvider.tokenCoin.color,
                    onTap: () => _onMarketSelection(context))),
            Container(
              decoration: BoxDecoration(
                color: coinProvider.tokenCoin.color.withOpacity(0.3),
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
                    Icons.arrow_drop_down,
                    color: coinProvider.tokenCoin.color,
                    size: 18,
                  ),
                  Text(
                    "${coinProvider.tokenCoin.percentage}%",
                    style: tsS14W600CFF.copyWith(
                        color: coinProvider.tokenCoin.color),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMarketSelection(BuildContext context) {
    Coordinator.goToMarketTokenSelectionScreen().then((model) {
      if (model != null) {
        final provider = context.read<TradeTabCoinProvider>();
        provider.tokenCoin = model.tokenModel;
        provider.pairCoin = model.pairModel;

        context.read<TickerCubit>().getLastTicker(
              leftTokenId: model.tokenModel.baseTokenId,
              rightTokenId: model.tokenModel.pairTokenId,
            );
      }
    });
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
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Consumer<TradeTabCoinProvider>(
            builder: (context, coinProvider, child) => Container(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  TokenUtils.tokenIdToAssetImg(
                      coinProvider.tokenCoin.baseTokenId),
                  width: 50,
                  height: 50,
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
                child: Consumer<TradeTabCoinProvider>(
                  builder: (context, coinProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${TokenUtils.tokenIdToAcronym(coinProvider.tokenCoin.baseTokenId)}/${TokenUtils.tokenIdToAcronym(coinProvider.pairCoin?.baseTokenId ?? '')}',
                        style: tsS20W600CFF,
                      ),
                      Text(
                        TokenUtils.tokenIdToFullName(
                            coinProvider.tokenCoin.baseTokenId),
                        style:
                            tsS14W400CFF.copyWith(color: AppColors.colorABB2BC),
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

  static _ThisInheritedWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ThisInheritedWidget>();
}
