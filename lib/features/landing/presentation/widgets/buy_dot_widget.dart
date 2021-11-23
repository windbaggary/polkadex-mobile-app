import "dart:math";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_horizontal_slider.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/features/landing/presentation/cubits/order_cubit.dart';
import 'package:polkadex/features/landing/presentation/widgets/loading_dots_widget.dart';
import 'package:polkadex/features/landing/presentation/widgets/quantity_input_widget.dart';

/// The callback type for buy or sell
typedef OnBuyOrSell = void Function(String price, String amount, double total);

/// The widget repesent the buy dot
class BuyDotWidget extends StatefulWidget {
  final double leftBalance;
  final double rightBalance;
  final String leftAsset;
  final String rightAsset;
  final OnBuyOrSell? onBuy;
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
        FocusScope.of(context).requestFocus(FocusNode());
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
                  color: color2E303C,
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
                              color: color8BA1BE.withOpacity(0.30),
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
                                      color: colorFFFFFF.withOpacity(0.70)),
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
                      padding: const EdgeInsets.only(top: 12, bottom: 24),
                      child: Align(
                        alignment: Alignment.center,
                        child: Builder(
                          builder: (context) =>
                              ValueListenableBuilder<EnumBuySell>(
                            valueListenable: widget.buySellNotifier,
                            builder: (context, enumBuySell, child) {
                              String btnText = "Buy";
                              Color color;
                              switch (enumBuySell) {
                                case EnumBuySell.buy:
                                  btnText = "Buy";
                                  color = color0CA564;
                                  break;
                                case EnumBuySell.sell:
                                  btnText = "Sell";
                                  color = colorE6007A;
                                  break;
                              }
                              return InkWell(
                                onTap: () {
                                  switch (enumBuySell) {
                                    case EnumBuySell.buy:
                                      _onBuy(context);
                                      break;
                                    case EnumBuySell.sell:
                                      _onSell(context);
                                      break;
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: AppConfigs.animDurationSmall,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  padding:
                                      const EdgeInsets.fromLTRB(56, 15, 63, 14),
                                  child: BlocBuilder<OrderCubit, OrderState>(
                                    builder: (context, state) {
                                      if (state is OrderLoading) {
                                        return LoadingDotsWidget(dotSize: 10);
                                      }

                                      return Text(
                                        '$btnText DOT',
                                        style: tsS16W600CFF,
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
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
  void updatePrice(String text) {
    _priceController.text = text;
  }

  /// reset all the fields
  void reset() {
    _amountController.text = "";
    _priceController.text = "";
    _progressNotifier.value = 0.00;
  }

  /// A callback to handle when the user tap on buy button
  void _onBuy(BuildContext context) {
    final price = _ThisInheritedWidget.of(context)?.priceController.text;
    final amount = _ThisInheritedWidget.of(context)?.amountController.text;
    final total = _ThisInheritedWidget.of(context)?.progressNotifier.value;
    // if (price?.isEmpty ?? true) {
    //   buildAppToast(
    //     msg: "Please enter the price",
    //     context: context,
    //   );
    //   return;
    // }

    if (price?.isEmpty ?? true) {
      buildAppToast(msg: "Please enter the price", context: context);
      return;
    }

    try {
      final priceInDouble = double.tryParse(price!);
      final amountInDouble = double.tryParse(amount!);

      if (priceInDouble == null || amountInDouble == null) throw Exception();

      if (priceInDouble <= 0) {
        buildAppToast(
            msg: "Price should be greater than 0.00", context: context);
        return;
      }

      if (priceInDouble >= _walletBalance) {
        buildAppToast(
            msg: "Price should be less than wallet balance", context: context);
        return;
      }

      if (priceInDouble * amountInDouble > _walletBalance) {
        buildAppToast(
            msg: "Total should be equal or less than wallet balance",
            context: context);
        return;
      }

      if (widget.onBuy != null) {
        widget.onBuy!(price, amount, total!);
      }
    } catch (ex) {
      buildAppToast(msg: "Please enter a valid price", context: context);
      print(ex);
    }
  }

  /// A callback to handle when the user tap on sell button
  void _onSell(BuildContext context) {
    final price = _ThisInheritedWidget.of(context)?.priceController.text;
    final amount = _ThisInheritedWidget.of(context)?.amountController.text;
    final total = _ThisInheritedWidget.of(context)?.progressNotifier.value;
    // if (price?.isEmpty ?? true) {
    //   buildAppToast(
    //     msg: "Please enter the price",
    //     context: context,
    //   );
    //   return;
    // }

    if (price?.isEmpty ?? true) {
      buildAppToast(
        msg: "Please enter the price",
        context: context,
      );
      return;
    }

    try {
      final priceInDouble = double.tryParse(price!);
      final amountInDouble = double.tryParse(amount!);

      if (priceInDouble == null || amountInDouble == null) throw Exception();

      if (priceInDouble <= 0) {
        buildAppToast(
            msg: "Price should be greater than 0.00", context: context);
        return;
      }

      if (priceInDouble >= _walletBalance) {
        buildAppToast(
            msg: "Price should be less than wallet balance", context: context);
        return;
      }

      if (amountInDouble > _walletBalance) {
        buildAppToast(
            msg: "Amount should be equal or less than wallet balance",
            context: context);
        return;
      }

      if (widget.onBuy != null) {
        widget.onSell(price, amount, total!);
      }
    } catch (ex) {
      buildAppToast(msg: "Please enter a valid price", context: context);
      print(ex);
    }
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
      final double? value = double.tryParse(val);
      final double? price = double.tryParse(
          _ThisInheritedWidget.of(context)!.priceController.text);

      if (value == null || price == null) {
        return;
      }

      _ThisInheritedWidget.of(context)?.progressNotifier.value =
          (value * price) / _ThisInheritedWidget.of(context)!.walletBalance;
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
        return;
      }

      _ThisInheritedWidget.of(context)?.progressNotifier.value =
          ((amount * price) / _ThisInheritedWidget.of(context)!.walletBalance);
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
                    color = color0CA564;
                    break;
                  case EnumBuySell.sell:
                    color = colorE6007A;
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
  double progressFloor = _floorDecimalPrecision(progressNotifier, 2);
  double newAmount = walletBalance * progressFloor;

  final price = double.tryParse(priceController.text);

  if (price == null) {
    return;
  }

  if (buyOrSell == EnumBuySell.buy) {
    newAmount /= price;
  }

  amountController.text = _floorDecimalPrecision(newAmount, 4).toString();
}

double _floorDecimalPrecision(double value, int precision) {
  num mod = pow(10, precision);
  return (value * mod).floorToDouble() / mod;
}
