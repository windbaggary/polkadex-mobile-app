import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/cubits/account_cubit.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/orderbook/presentation/cubit/orderbook_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/list_orders_cubit/list_orders_cubit.dart';
import 'package:polkadex/features/landing/presentation/dialogs/trade_view_dialogs.dart';
import 'package:polkadex/features/landing/presentation/providers/home_scroll_notif_provider.dart';
import 'package:polkadex/features/landing/presentation/providers/trade_tab_provider.dart';
import 'package:polkadex/features/landing/presentation/widgets/buy_dot_widget.dart';
import 'package:polkadex/features/landing/presentation/widgets/order_item_widget.dart';
import 'package:polkadex/features/landing/presentation/cubits/place_order_cubit/place_order_cubit.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:polkadex/common/orderbook/presentation/widgets/order_book_widget.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
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
  final _keyBuySellWidget = GlobalKey<__ThisBuySellWidgetState>();
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

          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _ThisTopRowSelectWidget(),
                _ThisBuySellWidget(
                  key: _keyBuySellWidget,
                ),
                OrderBookWidget(
                  amountTokenId: context
                      .read<TradeTabCoinProvider>()
                      .tokenCoin
                      .pairTokenId,
                  priceTokenId: context
                      .read<TradeTabCoinProvider>()
                      .tokenCoin
                      .baseTokenId,
                ),
              ],
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

/// The card includes buy sell tab controller
class _ThisBuySellWidget extends StatefulWidget {
  _ThisBuySellWidget({
    required Key key,
  }) : super(key: key);

  @override
  __ThisBuySellWidgetState createState() => __ThisBuySellWidgetState();
}

class __ThisBuySellWidgetState extends State<_ThisBuySellWidget>
    with TickerProviderStateMixin {
  final _keyBuySellWidget = GlobalKey<BuyDotWidgetState>();

  late ValueNotifier<bool> _isOrdersExpanded;
  late ValueNotifier<EnumBuySell> _buySellNotifier;
  late ValueNotifier<EnumOrderTypes> _orderTypeSelNotifier;
  late ValueNotifier<EnumTradeOrdersDisplayType?> _orderDisplayTypeNotifier;

  @override
  void initState() {
    _orderTypeSelNotifier = ValueNotifier(EnumOrderTypes.market);
    _isOrdersExpanded = ValueNotifier(false);
    _orderDisplayTypeNotifier =
        ValueNotifier<EnumTradeOrdersDisplayType?>(null);
    _buySellNotifier = ValueNotifier(EnumBuySell.buy);
    super.initState();
    Future.microtask(() {
      final tabController =
          _ThisInheritedWidget.of(context)?.buySellTabController;
      tabController?.addListener(() => _onSwapBuySellTab(context));
    });
  }

  @override
  void dispose() {
    _buySellNotifier.dispose();
    _isOrdersExpanded.dispose();
    _orderTypeSelNotifier.dispose();
    _orderDisplayTypeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TradeTabCoinProvider>(
      builder: (context, coinProvider, child) =>
          BlocBuilder<BalanceCubit, BalanceState>(
        builder: (context, state) {
          final currentState = context.read<BalanceCubit>().state;
          double leftBalance = 0.0;
          double rightBalance = 0.0;

          if (currentState is BalanceLoaded && currentState.free.isNotEmpty) {
            leftBalance = double.tryParse(
                    currentState.free[coinProvider.tokenCoin.baseTokenId]) ??
                0.0;
            rightBalance = double.tryParse(
                    currentState.free[coinProvider.tokenCoin.pairTokenId]) ??
                0.0;
          }

          return Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: AppColors.color24252C,
              borderRadius: BorderRadius.circular(20),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 30,
                  offset: Offset(0.0, 20.0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 30, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ValueListenableBuilder<EnumBuySell>(
                          valueListenable: _buySellNotifier,
                          builder: (context, buyOrSell, child) {
                            Color color;
                            switch (buyOrSell) {
                              case EnumBuySell.buy:
                                color = AppColors.color0CA564;
                                break;
                              case EnumBuySell.sell:
                                color = AppColors.colorE6007A;
                                break;
                            }
                            return TabBar(
                              isScrollable: true,
                              labelStyle: tsS15W600CFF,
                              unselectedLabelColor:
                                  AppColors.colorFFFFFF.withOpacity(0.30),
                              indicatorColor: color,
                              indicatorSize: TabBarIndicatorSize.tab,
                              tabs: <Tab>[
                                Tab(
                                  text:
                                      'Buy ${TokenUtils.tokenIdToAcronym(coinProvider.tokenCoin.pairTokenId)}',
                                ),
                                Tab(
                                  text:
                                      'Sell ${TokenUtils.tokenIdToAcronym(coinProvider.tokenCoin.pairTokenId)}',
                                ),
                              ],
                              controller: _ThisInheritedWidget.of(context)
                                  ?.buySellTabController,
                            );
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () => _onTapOrderType(context),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: ValueListenableBuilder<EnumOrderTypes>(
                                valueListenable: _orderTypeSelNotifier,
                                builder: (context, type, _) => Text(
                                  _getOrderTypeName(type),
                                  style: tsS15W600CFF,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.colorFFFFFF,
                              size: 16,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                BuyDotWidget(
                  key: _keyBuySellWidget,
                  leftBalance: leftBalance,
                  leftAsset: coinProvider.tokenCoin.baseTokenId,
                  rightBalance: rightBalance,
                  rightAsset: coinProvider.tokenCoin.pairTokenId,
                  orderTypeNotifier: _orderTypeSelNotifier,
                  buySellNotifier: _buySellNotifier,
                  onSwapTab: () => _onClickArrowsBuySell(
                      _ThisInheritedWidget.of(context)?.buySellTabController),
                  onBuy: (price, amount) => _onBuyOrSell(
                    EnumBuySell.buy,
                    _orderTypeSelNotifier.value,
                    coinProvider.tokenCoin.baseTokenId,
                    coinProvider.tokenCoin.pairTokenId,
                    price,
                    amount,
                    context,
                  ),
                  onSell: (price, amount) => _onBuyOrSell(
                    EnumBuySell.sell,
                    _orderTypeSelNotifier.value,
                    coinProvider.tokenCoin.baseTokenId,
                    coinProvider.tokenCoin.pairTokenId,
                    price,
                    amount,
                    context,
                  ),
                  isBalanceLoading:
                      context.read<BalanceCubit>().state is! BalanceLoaded,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                    left: 41,
                    right: 41,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (_orderDisplayTypeNotifier.value ==
                              EnumTradeOrdersDisplayType.open) {
                            if (_isOrdersExpanded.value) {
                              _isOrdersExpanded.value = false;
                            } else {
                              _isOrdersExpanded.value = true;
                            }
                          } else {
                            _orderDisplayTypeNotifier.value =
                                EnumTradeOrdersDisplayType.open;
                            if (!_isOrdersExpanded.value) {
                              _isOrdersExpanded.value = true;
                            }
                          }
                        },
                        child: BlocBuilder<ListOrdersCubit, ListOrdersState>(
                            builder: (context, state) {
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, right: 12),
                                child: Text(
                                  "Open Orders",
                                  style: state is ListOrdersLoaded &&
                                          state.openOrders.isEmpty
                                      ? tsS15W600CABB2BC
                                      : tsS15W600CFF,
                                ),
                              ),
                              if (state is! ListOrdersError)
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.colorE6007A,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(
                                      state is ListOrdersLoading ? 2.5 : 4),
                                  margin: const EdgeInsets.only(bottom: 4),
                                  child: state is ListOrdersLoaded
                                      ? Text('${state.openOrders.length}',
                                          style: tsS10W500CFF)
                                      : SizedBox(
                                          width: 6.0,
                                          height: 6.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1.5,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _isOrdersExpanded,
                  builder: (context, isShow, child) => AnimatedSize(
                    duration: AppConfigs.animDurationSmall,
                    alignment: Alignment.topCenter,
                    child: ValueListenableBuilder<EnumTradeOrdersDisplayType?>(
                      valueListenable: _orderDisplayTypeNotifier,
                      builder: (context, orderDisplayType, child) {
                        if (!(isShow)) return SizedBox(height: 15);
                        return _ThisOpenOrderExpandedWidget(
                          type: orderDisplayType,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// The callback listener for otder type selection
  void _onTapOrderType(BuildContext context) {
    showOrderTypeDialog(
      context: context,
      selectedIndex: _orderTypeSelNotifier.value,
      onItemSelected: (index) => _orderTypeSelNotifier.value = index,
    );
  }

  /// The callback listener when the user buy or sell from the buyorsellwidget
  void _onBuyOrSell(
    EnumBuySell type,
    EnumOrderTypes side,
    String leftAsset,
    String rightAsset,
    String price,
    String amount,
    BuildContext context,
  ) async {
    final placeOrderCubit = context.read<PlaceOrderCubit>();
    final listOrdersCubit = context.read<ListOrdersCubit>();

    FocusManager.instance.primaryFocus?.unfocus();

    final resultPlaceOrder = await placeOrderCubit.placeOrder(
      nonce: 0,
      baseAsset: leftAsset,
      quoteAsset: rightAsset,
      orderType: side,
      orderSide: type,
      quantity: double.parse(amount),
      price: double.parse(price),
      address: context.read<AccountCubit>().accountAddress,
      signature: context.read<AccountCubit>().accountSignature,
    );

    if (price.isEmpty) {
      price = amount;
    }

    if (resultPlaceOrder != null) {
      listOrdersCubit.addToOpenOrders(resultPlaceOrder);
    }

    final orderType = type == EnumBuySell.buy ? 'Purchase' : 'Sale';
    final message = context.read<PlaceOrderCubit>().state is PlaceOrderAccepted
        ? '$orderType added to open orders.'
        : '$orderType not accepted. Please try again.';
    buildAppToast(msg: message, context: context);
    _keyBuySellWidget.currentState?.reset();
  }

  /// Returns the order type string from the [type]
  String _getOrderTypeName(EnumOrderTypes type) {
    switch (type) {
      case EnumOrderTypes.market:
        return "Market Order";
      case EnumOrderTypes.limit:
        return "Limit Order";
      case EnumOrderTypes.stop:
        return "Stop Order";
    }
  }

  void _onSwapBuySellTab(BuildContext context) {
    final tabController =
        _ThisInheritedWidget.of(context)?.buySellTabController;

    _buySellNotifier.value = EnumBuySell.values[tabController!.index];
  }

  void _onClickArrowsBuySell(TabController? buySellTabController) {
    int newIndex = 0;
    if (buySellTabController?.index == 0) {
      newIndex = 1;
    }

    buySellTabController?.animateTo(newIndex);
  }
}

/// This widget will be shown when the user click on open orders
class _ThisOpenOrderExpandedWidget extends StatelessWidget {
  final EnumTradeOrdersDisplayType? type;
  const _ThisOpenOrderExpandedWidget({
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 8),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 104,
            height: 4,
            margin: const EdgeInsets.only(bottom: 2.5, left: 40, right: 40),
            decoration: BoxDecoration(
              color: AppColors.colorE6007A,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 8),
        BlocBuilder<ListOrdersCubit, ListOrdersState>(
          builder: (context, state) {
            if (state is ListOrdersLoaded) {
              return Column(
                children: state.openOrders
                    .map<Widget>(
                      (order) => OrderItemWidget(
                        order: order,
                        isProcessing:
                            state.orderUuidsLoading.contains(order.uuid),
                        onTapClose: () async {
                          final cancelSuccess = await context
                              .read<ListOrdersCubit>()
                              .cancelOrder(
                                order,
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
}

/// The top widget of the screen
/// The widget include the selection and percentage
class _ThisTopRowSelectWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 8, right: 19),
      child: Consumer<TradeTabCoinProvider>(
        builder: (context, coinProvider, child) => Row(
          children: [
            _ThisTopSelectableWidget(onTap: () => _onMarketSelection(context)),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                color: coinProvider.tokenCoin.color,
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(3),
              margin: const EdgeInsets.only(right: 13.5),
              child: Text(
                "${coinProvider.tokenCoin.percentage}%",
                style: tsS13W600CFF,
              ),
            ),
            buildInkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => Coordinator.goToCoinTradeScreen(
                leftTokenId: coinProvider.tokenCoin.baseTokenId,
                rightTokenId: coinProvider.tokenCoin.pairTokenId,
                balanceCubit: context.read<BalanceCubit>(),
                orderbookCubit: context.read<OrderbookCubit>(),
              ),
              child: Container(
                width: 33,
                height: 33,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.color8BA1BE.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset('trading'.asAssetSvg()),
              ),
            )
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
      }
    });
  }
}

/// The widget to handle the ontap for picker
///
class _ThisTopSelectableWidget extends StatelessWidget {
  final VoidCallback? onTap;
  const _ThisTopSelectableWidget({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Consumer<TradeTabCoinProvider>(
            builder: (context, coinProvider, child) => Image.asset(
              TokenUtils.tokenIdToAssetImg(coinProvider.tokenCoin.baseTokenId),
              width: 48,
              height: 48,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 7,
              right: 18,
            ),
            child: Consumer<TradeTabCoinProvider>(
              builder: (context, coinProvider, child) => Column(
                children: [
                  RichText(
                    text: TextSpan(
                      style: tsS14W500CFF,
                      children: <TextSpan>[
                        TextSpan(
                          text: TokenUtils.tokenIdToAcronym(
                              coinProvider.tokenCoin.baseTokenId),
                          style: TextStyle(fontSize: 19),
                        ),
                        TextSpan(
                          text:
                              '/${TokenUtils.tokenIdToAcronym(coinProvider.pairCoin?.baseTokenId ?? '')}',
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    TokenUtils.tokenIdToFullName(
                        coinProvider.tokenCoin.baseTokenId),
                    style: tsS15W500CFF.copyWith(color: AppColors.colorABB2BC),
                  )
                ],
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.colorFFFFFF,
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
