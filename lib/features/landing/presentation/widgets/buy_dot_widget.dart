import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/math_utils.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/widgets/app_horizontal_slider.dart';
import 'package:polkadex/features/landing/presentation/cubits/place_order_cubit/place_order_cubit.dart';
import 'package:polkadex/common/widgets/loading_dots_widget.dart';
import 'package:polkadex/features/landing/presentation/widgets/quantity_input_widget.dart';

/// The callback type for buy or sell
typedef OnBuyOrSell = void Function(String price, String amount);

/// The widget repesent the buy dot
class BuyDotWidget extends StatefulWidget {
  final double leftBalance;
  final double rightBalance;
  final String leftAsset;
  final String rightAsset;
  final OnBuyOrSell onBuy;
  final OnBuyOrSell onSell;
  final ValueNotifier<EnumBuySell> buySellNotifier;
  final ValueNotifier<EnumOrderTypes> orderTypeNotifier;
  final VoidCallback? onSwapTab;

  const BuyDotWidget({
    required Key key,
    required this.leftBalance,
    required this.rightBalance,
    required this.leftAsset,
    required this.rightAsset,
    required this.buySellNotifier,
    required this.onSell,
    required this.onBuy,
    required this.orderTypeNotifier,
    this.onSwapTab,
  }) : super(key: key);

  @override
  BuyDotWidgetState createState() => BuyDotWidgetState();
}

class BuyDotWidgetState extends State<BuyDotWidget>
    with TickerProviderStateMixin {
  late TextEditingController _priceController;
  late TextEditingController _amountController;
  late ValueNotifier<double> _progressNotifier;
  late ValueNotifier<double?> _totalNotifier;
  late ValueNotifier<EnumAmountType> _amountTypeNotifier;
  late double _walletBalance;

  String _asset = 'BTC';

  @override
  void initState() {
    _priceController = TextEditingController();
    _amountController = TextEditingController();
    _progressNotifier = ValueNotifier<double>(0.00);
    _totalNotifier = ValueNotifier<double?>(null);
    _amountTypeNotifier = ValueNotifier(EnumAmountType.usd);
    _walletBalance = widget.leftBalance;
    context.read<PlaceOrderCubit>().updateOrderParams(
          balance: widget.leftBalance,
          orderside: EnumBuySell.buy,
        );
    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _amountController.dispose();
    _progressNotifier.dispose();
    _amountTypeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: ValueListenableBuilder<EnumBuySell>(
        valueListenable: widget.buySellNotifier,
        builder: (context, buyOrSell, child) {
          switch (buyOrSell) {
            case EnumBuySell.buy:
              _asset = 'BTC';
              _walletBalance = widget.leftBalance;
              break;
            case EnumBuySell.sell:
              _asset = 'DOT';
              _walletBalance = widget.rightBalance;
              break;
          }

          if (_progressNotifier.value > 1.0) {
            _progressNotifier.value = 1.0;
          }

          _onProgressOrOrderSideUpdate(
            buyOrSell,
            _walletBalance,
            _progressNotifier.value,
            _amountController,
            _priceController,
            context,
          );

          return _ThisInheritedWidget(
            amountController: _amountController,
            priceController: _priceController,
            buySellNotifier: widget.buySellNotifier,
            totalNotifier: _totalNotifier,
            progressNotifier: _progressNotifier,
            orderTypeNotifier: widget.orderTypeNotifier,
            amountTypeNotifier: _amountTypeNotifier,
            walletBalance: _walletBalance,
            asset: _asset,
            child: Builder(
              builder: (context) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.color2E303C,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.17),
                      blurRadius: 99,
                      offset: Offset(0.0, 100.0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(24, 16, 33, 12.02 - 9.5),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            margin: const EdgeInsets.only(right: 9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.color8BA1BE.withOpacity(0.30),
                            ),
                            padding: const EdgeInsets.all(11),
                            child: SvgPicture.asset('wallet'.asAssetSvg()),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "My balance",
                                  style: tsS14W500CFF.copyWith(
                                      color: AppColors.colorFFFFFF
                                          .withOpacity(0.70)),
                                ),
                                Text(
                                  '${_walletBalance.toStringAsFixed(2)} $_asset',
                                  style: tsS20W500CFF,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: widget.onSwapTab,
                            child: ValueListenableBuilder<EnumBuySell>(
                              valueListenable: widget.buySellNotifier,
                              builder: (context, buyOrSell, child) {
                                String svg;
                                switch (buyOrSell) {
                                  case EnumBuySell.buy:
                                    svg = 'tradeArrowsBuy'.asAssetSvg();

                                    break;
                                  case EnumBuySell.sell:
                                    svg = 'tradeArrows'.asAssetSvg();
                                    break;
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    svg,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    ValueListenableBuilder<EnumOrderTypes>(
                        valueListenable: _ThisInheritedWidget.of(context)
                                ?.orderTypeNotifier ??
                            ValueNotifier(EnumOrderTypes.market),
                        builder: (context, orderType, child) {
                          Widget contentChild = child!;
                          // if (orderType == EnumOrderTypes.Market) {
                          //   contentChild = Container();
                          // }
                          return AnimatedSize(
                            duration: AppConfigs.animDurationSmall,
                            child: contentChild,
                          );
                        },
                        child: _ThisAmountWidget()),
                    _ThisPriceWidget(),
                    _ThisTotalWidget(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Align(
                        alignment: Alignment.center,
                        child: BlocBuilder<PlaceOrderCubit, PlaceOrderState>(
                          builder: (context, state) {
                            final tapFunction =
                                state.orderSide == EnumBuySell.buy
                                    ? widget.onBuy
                                    : widget.onSell;

                            if (state is PlaceOrderLoading) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 28),
                                child: LoadingDotsWidget(
                                  dotSize: 10,
                                ),
                              );
                            }

                            return AppButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 64),
                              label:
                                  '${state.orderSide == EnumBuySell.buy ? 'Buy' : 'Sell'} ${widget.rightAsset}',
                              enabled: state is! PlaceOrderNotValid,
                              onTap: () => state is PlaceOrderValid
                                  ? tapFunction(
                                      state.price.toString(),
                                      state.amount.toString(),
                                    )
                                  : {},
                              backgroundColor:
                                  state.orderSide == EnumBuySell.buy
                                      ? AppColors.color0CA564
                                      : AppColors.colorE6007A,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Update the price to [text]
  void updatePrice(double price) {
    _priceController.text = price.toString();
  }

  /// reset all the fields
  void reset() {
    _amountController.text = "";
    _priceController.text = "";
    _progressNotifier.value = 0.00;
  }
}

class _ThisAmountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ThisCard(
      child: Row(
        children: [
          Expanded(
            child: QuantityInputWidget(
              hintText: 'Amount',
              controller: _ThisInheritedWidget.of(context)?.amountController,
              onChanged: (amount) => _onAmountChanged(amount, context),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.17),
                  blurRadius: 99,
                  offset: Offset(0.0, 100.0),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 10),
            child: Row(
              children: [
                Image.asset(
                  'tokenIcon.png'.asAssetImg(),
                  width: 17,
                  height: 17,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    'DOT',
                    style: tsS13W600CFF,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onAmountChanged(String val, BuildContext context) {
    try {
      final double? amount = double.tryParse(val);
      final double? price = double.tryParse(
          _ThisInheritedWidget.of(context)!.priceController.text);

      if (amount == null || price == null) {
        _ThisInheritedWidget.of(context)?.progressNotifier.value = 0.0;
        return;
      }

      _ThisInheritedWidget.of(context)?.progressNotifier.value =
          (amount * price) / _ThisInheritedWidget.of(context)!.walletBalance;

      context.read<PlaceOrderCubit>().updateOrderParams(
            orderside: _ThisInheritedWidget.of(context)!.buySellNotifier.value,
            amount: amount,
            price: price,
          );
    } catch (ex) {
      print(ex);
    }
  }
}

class _ThisPriceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ThisCard(
      child: Row(
        children: [
          Expanded(
            child: QuantityInputWidget(
              hintText: "Price",
              controller: _ThisInheritedWidget.of(context)?.priceController,
              onChanged: (price) => _onPriceChanged(
                _ThisInheritedWidget.of(context)?.buySellNotifier.value,
                price,
                context,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.17),
                  blurRadius: 99,
                  offset: Offset(0.0, 100.0),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 10),
            child: Row(
              children: [
                Image.asset(
                  'tokenIcon.png'.asAssetImg(),
                  width: 17,
                  height: 17,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    'BTC',
                    style: tsS13W600CFF,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onPriceChanged(
      EnumBuySell? buyOrSell, String val, BuildContext context) {
    try {
      final double? amount = double.tryParse(
          _ThisInheritedWidget.of(context)!.amountController.text);
      final double? price = double.tryParse(val);

      if (amount == null || price == null) {
        _ThisInheritedWidget.of(context)?.progressNotifier.value = 0.0;
        return;
      }

      _ThisInheritedWidget.of(context)?.progressNotifier.value =
          ((amount * price) / _ThisInheritedWidget.of(context)!.walletBalance);

      context.read<PlaceOrderCubit>().updateOrderParams(
            orderside: _ThisInheritedWidget.of(context)!.buySellNotifier.value,
            amount: amount,
            price: price,
          );
    } catch (ex) {
      print(ex);
    }
  }
}

class _ThisTotalWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _ThisCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ValueListenableBuilder<EnumAmountType>(
                  valueListenable:
                      _ThisInheritedWidget.of(context)?.amountTypeNotifier ??
                          ValueNotifier(EnumAmountType.usd),
                  builder: (context, amountType, child) =>
                      ValueListenableBuilder<double>(
                    valueListenable:
                        _ThisInheritedWidget.of(context)?.progressNotifier ??
                            ValueNotifier<double>(0.00),
                    builder: (context, progress, child) {
                      String? totalAmount;
                      try {
                        final double? amount = double.tryParse(
                            _ThisInheritedWidget.of(context)!
                                .amountController
                                .text);
                        final double? price = double.tryParse(
                            _ThisInheritedWidget.of(context)!
                                .priceController
                                .text);

                        totalAmount = amount != null && price != null
                            ? (amount * price).toString()
                            : null;
                      } on Exception catch (ex) {
                        print(ex);
                      }
                      if ((totalAmount?.isEmpty ?? true) || (progress == 0.0)) {
                        totalAmount = "Total";
                      }
                      return Text(
                        totalAmount ?? "Total",
                        style: tsS16W500CFF,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 19),
            child: ValueListenableBuilder<EnumBuySell>(
              valueListenable:
                  _ThisInheritedWidget.of(context)?.buySellNotifier ??
                      ValueNotifier(EnumBuySell.buy),
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
                return ValueListenableBuilder<double>(
                  valueListenable:
                      _ThisInheritedWidget.of(context)?.progressNotifier ??
                          ValueNotifier<double>(0.00),
                  builder: (context, progress, child) => AppHorizontalSlider(
                    initialProgress: progress.clamp(0.0, 1.0),
                    activeColor: color,
                    onProgressUpdate: (progress) {
                      _ThisInheritedWidget.of(context)?.progressNotifier.value =
                          progress;
                      _onProgressOrOrderSideUpdate(
                        buyOrSell,
                        _ThisInheritedWidget.of(context)!.walletBalance,
                        progress,
                        _ThisInheritedWidget.of(context)!.amountController,
                        _ThisInheritedWidget.of(context)!.priceController,
                        context,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// The common card layout for the widget
class _ThisCard extends StatelessWidget {
  final Widget? child;
  const _ThisCard({
    this.child,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(13, 6.5, 13, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.20),
      ),
      padding: const EdgeInsets.fromLTRB(20, 8, 13, 8),
      child: child,
    );
  }
}

/// The inherited widget for the screen to pass the parameters
class _ThisInheritedWidget extends InheritedWidget {
  final TextEditingController priceController;
  final TextEditingController amountController;
  final ValueNotifier<double> progressNotifier;
  final ValueNotifier<double?> totalNotifier;
  final ValueNotifier<EnumBuySell> buySellNotifier;
  final ValueNotifier<EnumOrderTypes> orderTypeNotifier;
  final ValueNotifier<EnumAmountType> amountTypeNotifier;
  final double walletBalance;
  final String asset;

  _ThisInheritedWidget({
    required this.priceController,
    required this.amountController,
    required this.progressNotifier,
    required this.totalNotifier,
    required this.buySellNotifier,
    required this.orderTypeNotifier,
    required this.walletBalance,
    required this.asset,
    required this.amountTypeNotifier,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant _ThisInheritedWidget oldWidget) {
    return oldWidget.amountController != amountController ||
        oldWidget.priceController != priceController ||
        oldWidget.progressNotifier != progressNotifier ||
        oldWidget.totalNotifier != totalNotifier ||
        oldWidget.buySellNotifier != buySellNotifier ||
        oldWidget.orderTypeNotifier != orderTypeNotifier ||
        oldWidget.walletBalance != walletBalance ||
        oldWidget.asset != asset ||
        oldWidget.amountTypeNotifier != amountTypeNotifier;
  }

  static _ThisInheritedWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ThisInheritedWidget>();
}

void _onProgressOrOrderSideUpdate(
  EnumBuySell buyOrSell,
  double walletBalance,
  double progressNotifier,
  TextEditingController amountController,
  TextEditingController priceController,
  BuildContext context,
) {
  double progressFloor = MathUtils.floorDecimalPrecision(progressNotifier, 2);
  double newAmount = walletBalance * progressFloor;

  final price = double.tryParse(priceController.text);

  if (price == null) {
    return;
  }

  if (buyOrSell == EnumBuySell.buy) {
    newAmount /= price;
  }

  newAmount = MathUtils.floorDecimalPrecision(newAmount, 4);
  amountController.text = newAmount.toString();

  context.read<PlaceOrderCubit>().updateOrderParams(
        orderside: buyOrSell,
        balance: walletBalance,
        amount: newAmount,
        price: price,
      );
}
