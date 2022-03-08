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
import 'package:polkadex/features/landing/presentation/cubits/ticker_cubit/ticker_cubit.dart';
import 'package:polkadex/features/landing/presentation/widgets/order_quantity_widget.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:shimmer/shimmer.dart';

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
  final bool isBalanceLoading;

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
    required this.isBalanceLoading,
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
  late ValueNotifier<EnumAmountType> _amountTypeNotifier;
  late double _walletBalance;

  String _asset = 'BTC';

  @override
  void initState() {
    _priceController = TextEditingController();
    _amountController = TextEditingController();
    _progressNotifier = ValueNotifier<double>(0.00);
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
              _asset = TokenUtils.tokenIdToAcronym(widget.rightAsset);
              _walletBalance = widget.rightBalance;
              break;
            case EnumBuySell.sell:
              _asset = TokenUtils.tokenIdToAcronym(widget.leftAsset);
              _walletBalance = widget.leftBalance;
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

          return Container(
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
                  padding: const EdgeInsets.fromLTRB(24, 16, 33, 12.02 - 9.5),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My balance",
                              style: tsS14W500CFF.copyWith(
                                  color:
                                      AppColors.colorFFFFFF.withOpacity(0.70)),
                            ),
                            widget.isBalanceLoading
                                ? _orderBalanceShimmerWidget()
                                : Text(
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
                  valueListenable: widget.orderTypeNotifier,
                  builder: (context, orderType, child) {
                    return AnimatedSize(
                      duration: AppConfigs.animDurationSmall,
                      child: BlocBuilder<TickerCubit, TickerState>(
                        builder: (context, state) {
                          if (state is TickerLoaded) {
                            final newPrice = state.ticker.last.isNotEmpty
                                ? state.ticker.last
                                : state.ticker.previousClose;

                            _priceController.text = newPrice;
                            WidgetsBinding.instance?.addPostFrameCallback((_) =>
                                _onPriceAmountChanged(
                                    context, _walletBalance, newPrice, false));
                          }

                          return IgnorePointer(
                            ignoring: orderType == EnumOrderTypes.market &&
                                state is TickerLoaded,
                            child: OrderQuantityWidget(
                              controller: _priceController,
                              onChanged: (price) => _onPriceAmountChanged(
                                  context, _walletBalance, price, false),
                              tokenId: widget.rightAsset,
                              hintText: 'Price',
                              isLoading: orderType == EnumOrderTypes.market &&
                                  state is TickerLoading,
                              onError: orderType == EnumOrderTypes.market &&
                                      state is TickerError
                                  ? () =>
                                      context.read<TickerCubit>().getLastTicker(
                                            leftTokenId: widget.leftAsset,
                                            rightTokenId: widget.rightAsset,
                                          )
                                  : null,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                OrderQuantityWidget(
                  controller: _amountController,
                  onChanged: (amount) => _onPriceAmountChanged(
                    context,
                    _walletBalance,
                    amount,
                    true,
                  ),
                  tokenId: widget.leftAsset,
                  hintText: 'Amount',
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(13, 6.5, 13, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black.withOpacity(0.20),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 8, 13, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ValueListenableBuilder<double>(
                              valueListenable: _progressNotifier,
                              builder: (context, progress, child) {
                                String? totalAmount;
                                try {
                                  final double? amount =
                                      double.tryParse(_amountController.text);
                                  final double? price =
                                      double.tryParse(_priceController.text);

                                  totalAmount = amount != null && price != null
                                      ? (amount * price).toString()
                                      : null;
                                } on Exception catch (ex) {
                                  print(ex);
                                }
                                if ((totalAmount?.isEmpty ?? true) ||
                                    (progress == 0.0)) {
                                  totalAmount = "Total";
                                }
                                return Text(
                                  totalAmount ?? "Total",
                                  style: tsS16W500CFF,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 19),
                        child: ValueListenableBuilder<EnumBuySell>(
                          valueListenable: widget.buySellNotifier,
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
                              valueListenable: _progressNotifier,
                              builder: (context, progress, child) {
                                return AppHorizontalSlider(
                                  initialProgress: progress.clamp(0.0, 1.0),
                                  activeColor: color,
                                  onProgressUpdate: (progress) {
                                    _progressNotifier.value = progress;
                                    _onProgressOrOrderSideUpdate(
                                      buyOrSell,
                                      _walletBalance,
                                      progress,
                                      _amountController,
                                      _priceController,
                                      context,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Align(
                    alignment: Alignment.center,
                    child: BlocBuilder<PlaceOrderCubit, PlaceOrderState>(
                      builder: (context, state) {
                        final tapFunction = state.orderSide == EnumBuySell.buy
                            ? widget.onBuy
                            : widget.onSell;

                        if (state is PlaceOrderLoading) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 28),
                            child: LoadingDotsWidget(
                              dotSize: 10,
                            ),
                          );
                        }

                        return ValueListenableBuilder<EnumOrderTypes>(
                          valueListenable: widget.orderTypeNotifier,
                          builder: (_, __, ___) => AppButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 64),
                            label:
                                '${state.orderSide == EnumBuySell.buy ? 'Buy' : 'Sell'} ${TokenUtils.tokenIdToAcronym(widget.leftAsset)}',
                            enabled: _isPlaceOrderButtonEnabled(),
                            onTap: () => state is PlaceOrderValid
                                ? tapFunction(
                                    state.price.toString(),
                                    state.amount.toString(),
                                  )
                                : {},
                            backgroundColor: state.orderSide == EnumBuySell.buy
                                ? AppColors.color0CA564
                                : AppColors.colorE6007A,
                          ),
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

  bool _isPlaceOrderButtonEnabled() {
    return widget.orderTypeNotifier.value == EnumOrderTypes.market
        ? context.read<TickerCubit>().state is TickerLoaded &&
            context.read<PlaceOrderCubit>().state is! PlaceOrderNotValid
        : context.read<PlaceOrderCubit>().state is! PlaceOrderNotValid;
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

  Widget _orderBalanceShimmerWidget() {
    return Shimmer.fromColors(
      highlightColor: AppColors.color8BA1BE,
      baseColor: AppColors.color2E303C,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
        ),
        child: Text(
          '0.00 PDOG',
          style: tsS20W500CFF,
        ),
      ),
    );
  }

  void _onPriceAmountChanged(
    BuildContext context,
    double walletBalance,
    String val,
    bool isAmount,
  ) {
    double amount;
    double price;

    try {
      if (isAmount) {
        amount = double.tryParse(val) ?? 0.0;
        price = double.tryParse(_priceController.text) ?? 0.0;
      } else {
        amount = double.tryParse(_amountController.text) ?? 0.0;
        price = double.tryParse(val) ?? 0.0;
      }

      if (_walletBalance > 0.0) {
        _progressNotifier.value = ((amount * price) / _walletBalance);
      } else {
        _progressNotifier.value = 0.0;
      }

      context.read<PlaceOrderCubit>().updateOrderParams(
            orderside: widget.buySellNotifier.value,
            balance: walletBalance,
            amount: amount,
            price: price,
          );
    } catch (ex) {
      print(ex);
    }
  }
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
    context.read<PlaceOrderCubit>().updateOrderParams(orderside: buyOrSell);
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
