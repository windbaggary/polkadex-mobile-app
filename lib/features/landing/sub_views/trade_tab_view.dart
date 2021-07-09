import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/configs/app_config.dart';
import 'package:polkadex/features/landing/dialogs/trade_view_dialogs.dart';
import 'package:polkadex/features/landing/models/trade_models.dart';
import 'package:polkadex/features/landing/providers/home_scroll_notif_provider.dart';
import 'package:polkadex/features/landing/providers/trade_tab_provider.dart';
import 'package:polkadex/features/landing/screens/market_token_selection_screen.dart';
import 'package:polkadex/features/landing/widgets/buy_dot_widget.dart';
import 'package:polkadex/features/trade/order_book_item_model.dart';
import 'package:polkadex/features/trade/screens/coin_trade_screen.dart';
import 'package:polkadex/features/trade/widgets/order_book_widget.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:polkadex/utils/enums.dart';
import 'package:polkadex/utils/extensions.dart';
import 'package:polkadex/utils/styles.dart';
import 'package:polkadex/widgets/build_methods.dart';
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
  TabController _buySellDotController;
  ScrollController _scrollController;

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
    _buySellDotController = null;
  }

  @override
  Widget build(BuildContext context) {
    return _ThisInheritedWidget(
      buySellTabController: this._buySellDotController,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<TradeTabCoinProvider>(
              create: (context) => TradeTabCoinProvider()),
          ChangeNotifierProvider<TradeTabViewProvider>(
              create: (context) => TradeTabViewProvider()),
          ChangeNotifierProvider<OrderBookWidgetFilterProvider>(
            create: (context) => OrderBookWidgetFilterProvider(),
          ),
        ],
        builder: (context, _) => SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ThisTopRowSelectWidget(),
              _ThisBuySellWidget(
                key: _keyBuySellWidget,
              ),
              OrderBookHeadingWidget(),
              OrderBookWidget(
                onOrderBookItemClicked: (model) =>
                    _onOrderBookItemClicked(model, context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onOrderBookItemClicked(OrderBookItemModel model, BuildContext context) {
    _keyBuySellWidget.currentState.onOrderBookModelSelected(model);
  }

  void _scrollListener() {
    context.read<HomeScrollNotifProvider>().scrollOffset =
        _scrollController.offset;
  }
}

/// The card includes buy sell tab controller
class _ThisBuySellWidget extends StatefulWidget {
  _ThisBuySellWidget({
    Key key,
  }) : super(key: key);

  @override
  __ThisBuySellWidgetState createState() => __ThisBuySellWidgetState();
}

class __ThisBuySellWidgetState extends State<_ThisBuySellWidget>
    with TickerProviderStateMixin {
  final _keyBuySellWidget = GlobalKey<BuyDotWidgetState>();

  ValueNotifier<bool> _isOrdersExpanded;
  ValueNotifier<EnumBuySell> _buySellNotifier;
  ValueNotifier<EnumOrderTypes> _orderTypeSelNotifier;
  ValueNotifier<EnumTradeOrdersDisplayType> _orderDisplayTypeNotifier;

  @override
  void initState() {
    _orderTypeSelNotifier = ValueNotifier(EnumOrderTypes.Market);
    _isOrdersExpanded = ValueNotifier(false);
    _orderDisplayTypeNotifier = ValueNotifier<EnumTradeOrdersDisplayType>(null);
    _buySellNotifier = ValueNotifier(EnumBuySell.Buy);
    super.initState();
    Future.microtask(() {
      final tabController =
          _ThisInheritedWidget.of(context)?.buySellTabController;
      tabController.addListener(() {
        _buySellNotifier.value = EnumBuySell.values[tabController.index];
      });
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
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: color24252C,
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
                        case EnumBuySell.Buy:
                          color = color0CA564;
                          break;
                        case EnumBuySell.Sell:
                          color = colorE6007A;
                          break;
                          break;
                      }
                      return TabBar(
                        isScrollable: true,
                        labelStyle: tsS15W600CFF,
                        unselectedLabelColor: colorFFFFFF.withOpacity(0.30),
                        indicatorColor: color,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: <Tab>[
                          Tab(
                            text: 'Buy DOT',
                          ),
                          Tab(
                            text: 'Sell DOT',
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
                        color: colorFFFFFF,
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
            orderTypeNotifier: _orderTypeSelNotifier,
            buySellNotifier: _buySellNotifier,
            onSwapTab: () => _onSwapBuySellTab(context),
            onBuy: (price, amount, total) => _onBuyOrSell(
              EnumBuySell.Buy,
              price,
              amount,
              total,
              context,
            ),
            onSell: (price, amount, total) => _onBuyOrSell(
              EnumBuySell.Sell,
              price,
              amount,
              total,
              context,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 4.0,
              left: 41,
              right: 41,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    if (_orderDisplayTypeNotifier.value ==
                        EnumTradeOrdersDisplayType.Open) {
                      if (_isOrdersExpanded.value ?? false)
                        _isOrdersExpanded.value = false;
                      else
                        _isOrdersExpanded.value = true;
                    } else {
                      _orderDisplayTypeNotifier.value =
                          EnumTradeOrdersDisplayType.Open;
                      if (!_isOrdersExpanded.value) {
                        _isOrdersExpanded.value = true;
                      }
                    }
                  },
                  child: Consumer<TradeTabViewProvider>(
                    builder: (context, thisProvider, child) => Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, right: 12),
                          child: Text(
                            "Open Orders",
                            style: thisProvider.listOpenOrders.isNotEmpty
                                ? tsS15W600CFF
                                : tsS15W600CABB2BC,
                          ),
                        ),
                        if (thisProvider?.listOpenOrders?.isNotEmpty ?? false)
                          Container(
                            decoration: BoxDecoration(
                              color: colorE6007A,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.only(bottom: 4),
                            child: Text(
                                thisProvider?.listOpenOrders?.length
                                    ?.toString(),
                                style: tsS10W500CFF),
                          ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    if (_orderDisplayTypeNotifier.value ==
                        EnumTradeOrdersDisplayType.History) {
                      if (_isOrdersExpanded.value ?? false)
                        _isOrdersExpanded.value = false;
                      else
                        _isOrdersExpanded.value = true;
                    } else {
                      _orderDisplayTypeNotifier.value =
                          EnumTradeOrdersDisplayType.History;
                      if (!_isOrdersExpanded.value) {
                        _isOrdersExpanded.value = true;
                      }
                    }
                  },
                  child: Consumer<TradeTabViewProvider>(
                    builder: (context, thisProvider, child) => Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, right: 12),
                          child: Text(
                            "Orders History",
                            style: thisProvider.listOrdersHistory.isNotEmpty
                                ? tsS15W600CFF
                                : tsS15W600CABB2BC,
                          ),
                        ),
                        if (thisProvider?.listOrdersHistory?.isNotEmpty ??
                            false)
                          Container(
                            decoration: BoxDecoration(
                              color: colorE6007A,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            margin: const EdgeInsets.only(bottom: 4),
                            child: Text(
                                thisProvider?.listOrdersHistory?.length
                                    ?.toString(),
                                style: tsS10W500CFF),
                          ),
                      ],
                    ),
                  ),
                ),
                // Text(
                //   "Orders History",
                //   style: tsS15W600CABB2BC,
                //   textAlign: TextAlign.end,
                // ),
              ],
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isOrdersExpanded,
            builder: (context, isShow, child) => AnimatedSize(
              duration: AppConfigs.animDurationSmall,
              vsync: this,
              alignment: Alignment.topCenter,
              child: ValueListenableBuilder<EnumTradeOrdersDisplayType>(
                valueListenable: _orderDisplayTypeNotifier,
                builder: (context, orderDisplayType, child) {
                  if (!(isShow ?? false)) return SizedBox(height: 15);
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
  }

  /// The callback listener when the order book item is selected
  void onOrderBookModelSelected(OrderBookItemModel model) {
    _keyBuySellWidget.currentState.updatePrice(model.price);
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
    String price,
    String amount,
    double total,
    BuildContext context,
  ) {
    final thisProvider = context.read<TradeTabViewProvider>();
    if (price?.isEmpty ?? true) {
      price = amount;
    }
    thisProvider.addToListOrder(
      TradeOpenOrderModel(
        type: type,
        amount: amount,
        price: price,
        dateTime: DateTime.now(),
        amountCoin: "BTC",
        priceCoin: "DOT",
        tokenPairName: "DOT/BTC",
        orderType: _orderTypeSelNotifier.value,
      ),
    );

    buildAppToast(msg: "Purchase added to open orders", context: context);
    _keyBuySellWidget?.currentState?.reset();
  }

  /// Returns the order type string from the [type]
  String _getOrderTypeName(EnumOrderTypes type) {
    switch (type) {
      case EnumOrderTypes.Market:
        return "Market Order";
      case EnumOrderTypes.Limit:
        return "Limit Order";
      case EnumOrderTypes.Stop:
        return "Stop Order";
    }
    return null;
  }

  /// Listener to handle the Buy sell tab change
  void _onSwapBuySellTab(BuildContext context) {
    final tabController =
        _ThisInheritedWidget.of(context)?.buySellTabController;
    int newIndex = 0;
    if (tabController.index == 0) {
      newIndex = 1;
    }

    tabController.animateTo(newIndex);
  }
}

/// This widget will be shown when the user click on open orders
class _ThisOpenOrderExpandedWidget extends StatelessWidget {
  final EnumTradeOrdersDisplayType type;
  const _ThisOpenOrderExpandedWidget({
    Key key,
    @required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Alignment barAlignment = Alignment.centerLeft;
    double barWidth = 104;
    if (type == EnumTradeOrdersDisplayType.History) {
      barAlignment = Alignment.centerRight;
      barWidth = 127;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 8),
        Align(
          alignment: barAlignment,
          child: Container(
            width: barWidth,
            height: 4,
            margin: const EdgeInsets.only(bottom: 2.5, left: 40, right: 40),
            decoration: BoxDecoration(
              color: colorE6007A,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(height: 8),
        Consumer<TradeTabViewProvider>(
          builder: (context, thisProvider, child) {
            List<ITradeOpenOrderModel> list;
            switch (this.type) {
              case EnumTradeOrdersDisplayType.Open:
                list = thisProvider.listOpenOrders;
                break;
              case EnumTradeOrdersDisplayType.History:
                list = thisProvider.listOrdersHistory;
                break;
            }
            return Column(
              children: list
                      ?.map<Widget>((m) => _ThisOpenOrderItemWidget(
                            iModel: m,
                            onTapClose: () {
                              context
                                  .read<TradeTabViewProvider>()
                                  .removeItem(m);
                            },
                          ))
                      ?.toList() ??
                  <Widget>[],
            );
          },
        ),
      ],
    );
  }
}

class _ThisOpenOrderItemWidget extends StatelessWidget {
  final ITradeOpenOrderModel iModel;
  final VoidCallback onTapClose;
  const _ThisOpenOrderItemWidget({
    Key key,
    @required this.iModel,
    this.onTapClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color colorBuySell = color0CA564;
    if (iModel.iEnumType == EnumBuySell.Sell) {
      colorBuySell = colorE6007A;
    }
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: colorFFFFFF.withOpacity(0.05),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.17),
                blurRadius: 99,
                offset: Offset(0.0, 100.0),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.fromLTRB(27, 13, 19, 7),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color8BA1BE.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                margin: const EdgeInsets.only(right: 9),
                child: Text(
                  'Limit',
                  style: tsS16W500CFF,
                ),
              ),
              Text(
                'DOT/BTC',
                style: tsS15W600CFF,
              ),
              Spacer(),
              InkWell(
                onTap: this.onTapClose,
                child: SvgPicture.asset(
                  'close'.asAssetSvg(),
                  width: 10,
                  height: 10,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: color2E303C,
            borderRadius: BorderRadius.circular(16),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.17),
                blurRadius: 99,
                offset: Offset(0.0, 100.0),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(15, 15, 13, 19),
          margin: const EdgeInsets.only(left: 13, right: 13, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Type',
                          style: tsS14W400CFF.copyWith(color: colorABB2BC),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: colorBuySell.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: Text(
                            iModel?.iType ?? "",
                            style: tsS16W500CFF.copyWith(
                              color: colorBuySell,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount',
                          style: tsS14W400CFF.copyWith(color: colorABB2BC),
                        ),
                        SizedBox(height: 4),
                        Text(
                          iModel?.iAmount ?? "",
                          style: tsS16W500CFF,
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price',
                        style: tsS14W400CFF.copyWith(color: colorABB2BC),
                      ),
                      Text(
                        iModel?.iPrice ?? "",
                        style: tsS16W500CFF,
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  iModel?.iFormattedDate ?? "",
                  style: tsS14W400CFF.copyWith(color: colorABB2BC),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The top widget of the screen
/// The widget include the selection and percentage
class _ThisTopRowSelectWidget extends StatelessWidget {
  const _ThisTopRowSelectWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 8, right: 19),
      child: Row(
        children: [
          _ThisTopSelectableWidget(onTap: () => _onMarketSelection(context)),
          Spacer(),
          Consumer<TradeTabCoinProvider>(
            builder: (context, coinProvider, child) => Container(
              decoration: BoxDecoration(
                color: coinProvider?.tokenCoin?.color,
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(3),
              margin: const EdgeInsets.only(right: 13.5),
              child: Text(
                "${coinProvider?.tokenCoin?.percentage ?? ""}%",
                style: tsS13W600CFF,
              ),
            ),
          ),
          buildInkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CoinTradeScreen()));
            },
            child: Container(
              width: 33,
              height: 33,
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                color: color8BA1BE.withOpacity(0.20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset('trading'.asAssetSvg()),
            ),
          )
        ],
      ),
    );
  }

  void _onMarketSelection(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => MarketTokenSelectionScreen()))
        .then((model) {
      if (model != null && model is MarketSelectionResultModel) {
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
  final VoidCallback onTap;
  const _ThisTopSelectableWidget({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Consumer<TradeTabCoinProvider>(
            builder: (context, coinProvider, child) => Image.asset(
              coinProvider.tokenCoin.imgAsset,
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
                          text: coinProvider.tokenCoin.code,
                          style: TextStyle(fontSize: 19),
                        ),
                        TextSpan(
                          text: '/${coinProvider.pairCoin.code}',
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    coinProvider.tokenCoin.name,
                    style: tsS15W500CFF.copyWith(color: colorABB2BC),
                  )
                ],
              ),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: colorFFFFFF,
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
    @required this.buySellTabController,
    @required Widget child,
    Key key,
  }) : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant _ThisInheritedWidget oldWidget) {
    return oldWidget.buySellTabController != this.buySellTabController;
  }

  static _ThisInheritedWidget of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ThisInheritedWidget>();
}
