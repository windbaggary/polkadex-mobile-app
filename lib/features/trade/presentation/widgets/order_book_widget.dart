import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/features/landing/presentation/dialogs/trade_view_dialogs.dart';
import 'package:polkadex/features/landing/presentation/widgets/order_book_chart_item.dart';
import 'package:polkadex/features/trade/presentation/order_book_item_model.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:provider/provider.dart';

typedef OnOrderBookItemClicked = void Function(OrderBookItemModel model);

/// The order book widget
class OrderBookWidget extends StatelessWidget {
  final OnOrderBookItemClicked? onOrderBookItemClicked;
  const OrderBookWidget({
    this.onOrderBookItemClicked,
  });

  @override
  Widget build(BuildContext context) {
    return _ThisInheritedWidget(
      onOrderBookItemClicked: onOrderBookItemClicked,
      child: Column(
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
                    style: tsS20W600CFF.copyWith(color: AppColors.color0CA564),
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
            child: _ThisOrderBookChartWidget(),
          ),
        ],
      ),
    );
  }
}

/// The widget displays the chart on order book content
class _ThisOrderBookChartWidget extends StatelessWidget {
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
            _buildBuyWidget(),
          ],
        );
        break;
      case EnumBuySellAll.sell:
        child = Column(
          key: ValueKey("sell"),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeadingWidget(),
            _buildSellWidget(),
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
                  child: _buildHeadingWidget(),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildBuyWidget(),
                ),
                SizedBox(width: 7),
                Expanded(
                  child: _buildSellWidget(),
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

  Widget _buildSellWidget() => _ThisOrderSellWidget();

  Widget _buildBuyWidget() => _ThisOrderBuyWidget();

  Widget _buildHeadingWidget() => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Amount (PDEX)',
                style: tsS13W500CFFOP40,
              ),
            ),
            Text(
              'Price (BTC)',
              style: tsS13W500CFFOP40,
              textAlign: TextAlign.end,
            )
          ],
        ),
      );
}

class _ThisOrderSellWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dummySellChartList.sort((a, b) => b.amount.compareTo(a.amount));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(dummySellChartList.length,
          (index) => _OrderSellItemWidget(model: dummySellChartList[index])),
    );
  }
}

class _ThisOrderBuyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dummyBuyChartList.sort((a, b) => a.amount.compareTo(b.amount));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(dummyBuyChartList.length,
          (index) => _OrderBuyItemWidget(model: dummyBuyChartList[index])),
    );
  }
}

class _OrderBuyItemWidget extends StatelessWidget {
  final OrderBookItemModel model;

  const _OrderBuyItemWidget({required this.model});
  @override
  Widget build(BuildContext context) {
    return buildInkWell(
      onTap: _ThisInheritedWidget.of(context)?.onOrderBookItemClicked == null
          ? () {}
          : () =>
              _ThisInheritedWidget.of(context)?.onOrderBookItemClicked!(model),
      child: OrderBookChartItemWidget(
        percentage: model.percentage,
        direction: EnumGradientDirection.right,
        color: AppColors.color0CA564,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 6, 6, 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${model.amount}',
                  style: tsS14W500CFF,
                ),
              ),
              Text(
                '${model.price}',
                style: tsS14W500CFF.copyWith(color: AppColors.color0CA564),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderSellItemWidget extends StatelessWidget {
  final OrderBookItemModel model;

  const _OrderSellItemWidget({required this.model});
  @override
  Widget build(BuildContext context) {
    return buildInkWell(
      onTap: _ThisInheritedWidget.of(context)?.onOrderBookItemClicked == null
          ? () {}
          : () =>
              _ThisInheritedWidget.of(context)?.onOrderBookItemClicked!(model),
      child: OrderBookChartItemWidget(
        percentage: model.percentage,
        color: AppColors.colorE6007A,
        direction: EnumGradientDirection.left,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6.0, 6, 0, 6),
          child: Row(
            children: [
              Text(
                '${model.amount}',
                style: tsS14W500CFF.copyWith(color: AppColors.colorE6007A),
              ),
              Expanded(
                child: Text(
                  '${model.price}',
                  style: tsS14W500CFF,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The heading widget for the order book
class OrderBookHeadingWidget extends StatelessWidget {
  final _priceLengthNotifier = ValueNotifier<int>(0);
  final _dropDownValueNotifier = ValueNotifier<String>("Order Book");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 35, 22, 17),
      child: Row(
        children: [
          Expanded(
            // width: 100,
            child: ValueListenableBuilder<String>(
              valueListenable: _dropDownValueNotifier,
              builder: (context, dropDownValue, child) =>
                  DropdownButton<String>(
                items: ['Order Book', 'Deep Market']
                    .map((e) => DropdownMenuItem<String>(
                          child: Text(
                            e,
                            style: tsS20W600CFF,
                          ),
                          value: e,
                        ))
                    .toList(),
                value: dropDownValue,
                style: tsS20W600CFF,
                underline: Container(),
                onChanged: (val) {
                  _dropDownValueNotifier.value = val!;
                },
                isExpanded: false,
                icon: Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.colorFFFFFF,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
          ...EnumBuySellAll.values
              .map(
                (e) => Consumer<OrderBookWidgetFilterProvider>(
                  builder: (context, provider, child) {
                    String svg;
                    double padding = 8;
                    Color color = AppColors.color2E303C;

                    switch (e) {
                      case EnumBuySellAll.buy:
                        svg = 'orderbookBuy'.asAssetSvg();
                        if (provider.enumBuySellAll == EnumBuySellAll.buy) {
                          svg = 'orderbookBuySel'.asAssetSvg();
                        }
                        break;
                      case EnumBuySellAll.all:
                        svg = 'orderbookAll'.asAssetSvg();

                        break;
                      case EnumBuySellAll.sell:
                        svg = 'orderbookSell'.asAssetSvg();
                        if (provider.enumBuySellAll == EnumBuySellAll.sell) {
                          svg = 'orderbookSellSel'.asAssetSvg();
                        }
                        break;
                    }

                    if (provider.enumBuySellAll == e) {
                      padding = 5;
                      color = Colors.white;
                    }
                    return InkWell(
                      onTap: () {
                        provider.enumBuySellAll = e;
                      },
                      child: AnimatedContainer(
                        duration: AppConfigs.animDurationSmall,
                        padding: EdgeInsets.all(padding),
                        margin: const EdgeInsets.only(right: 7),
                        width: 31,
                        height: 31,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withOpacity(0.17),
                              blurRadius: 99,
                              offset: Offset(0.0, 100.0),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(svg),
                      ),
                    );
                  },
                ),
              )
              .toList(),
          InkWell(
            onTap: () {
              showPriceLengthDialog(
                context: context,
                selectedIndex: _priceLengthNotifier.value,
                onItemSelected: (index) => _priceLengthNotifier.value = index,
              );
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2, right: 4),
                  child: ValueListenableBuilder<int>(
                    valueListenable: _priceLengthNotifier,
                    builder: (context, selectedPriceLenIndex, child) => Text(
                      dummyPriceLengthData[selectedPriceLenIndex].price,
                      style: tsS15W600CFF.copyWith(
                          color: AppColors.colorFFFFFF.withOpacity(0.30)),
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
          ),
        ],
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

class _ThisInheritedWidget extends InheritedWidget {
  final OnOrderBookItemClicked? onOrderBookItemClicked;

  _ThisInheritedWidget(
      {required this.onOrderBookItemClicked, required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant _ThisInheritedWidget oldWidget) {
    return oldWidget.onOrderBookItemClicked != onOrderBookItemClicked;
  }

  static _ThisInheritedWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ThisInheritedWidget>();
}

final dummyBuyChartList = List.from(<OrderBookItemModel>[
  OrderBookItemModel(
    price: 0.7262,
    amount: 55.0,
    percentage: 0.35,
  ),
  OrderBookItemModel(
    price: 0.7262,
    amount: 65.0,
    percentage: 0.45,
  ),
  OrderBookItemModel(
    price: 0.7562,
    amount: 90.0,
    percentage: 0.80,
  ),
  OrderBookItemModel(
    price: 0.0262,
    amount: 8.0,
    percentage: 0.10,
  ),
  OrderBookItemModel(
    price: 0.1562,
    amount: 100.0,
    percentage: 0.95,
  ),
  OrderBookItemModel(
    price: 0.8653,
    amount: 87.0,
    percentage: 0.7,
  ),
  OrderBookItemModel(
    price: 0.7262,
    amount: 65.0,
    percentage: 0.45,
  ),
]);

final dummySellChartList = List.from(<OrderBookItemModel>[
  OrderBookItemModel(
    price: 0.7162,
    amount: 55.0,
    percentage: 0.35,
  ),
  OrderBookItemModel(
    price: 0.5609,
    amount: 65.0,
    percentage: 0.45,
  ),
  OrderBookItemModel(
    price: 0.4398,
    amount: 90.0,
    percentage: 0.80,
  ),
  OrderBookItemModel(
    price: 0.1853,
    amount: 8.0,
    percentage: 0.1,
  ),
  OrderBookItemModel(
    price: 0.3640,
    amount: 100.0,
    percentage: 0.95,
  ),
  OrderBookItemModel(
    price: 0.8219,
    amount: 87.0,
    percentage: 0.7,
  ),
  OrderBookItemModel(
    price: 0.7761,
    amount: 65.0,
    percentage: 0.45,
  ),
]);
