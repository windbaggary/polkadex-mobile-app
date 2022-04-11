import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/cubits/account_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/place_order_cubit/place_order_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/list_orders_cubit/list_orders_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/ticker_cubit/ticker_cubit.dart';
import 'package:polkadex/features/landing/presentation/dialogs/trade_view_dialogs.dart';
import 'package:polkadex/features/landing/presentation/providers/trade_tab_provider.dart';
import 'package:polkadex/common/widgets/app_horizontal_slider.dart';
import 'package:polkadex/common/widgets/loading_dots_widget.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/features/landing/presentation/widgets/quantity_input_widget.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:polkadex/common/utils/math_utils.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PlaceOrderWidget extends StatefulWidget {
  @override
  State<PlaceOrderWidget> createState() => _PlaceOrderWidgetState();
}

class _PlaceOrderWidgetState extends State<PlaceOrderWidget> {
  final ValueNotifier<EnumOrderTypes> _orderTypeNotifier =
      ValueNotifier(EnumOrderTypes.market);
  final ValueNotifier<double> _progressNotifier = ValueNotifier(0.0);
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<TradeTabCoinProvider>(builder: (context, coinProvider, _) {
      _onUpdateAvailableBalance(
          baseTokenId: coinProvider.tokenCoin.baseTokenId,
          pairTokenId: coinProvider.tokenCoin.pairTokenId);

      return BlocBuilder<PlaceOrderCubit, PlaceOrderState>(
        builder: (context, placeOrderState) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buySellWidget(
              buySellEnumValue: placeOrderState.orderSide,
              onBuyTap: () {
                _onUpdateAvailableBalance(
                    orderSide: EnumBuySell.buy,
                    baseTokenId: coinProvider.tokenCoin.baseTokenId,
                    pairTokenId: coinProvider.tokenCoin.pairTokenId);
                _onProgressOrOrderSideUpdate(
                  EnumBuySell.buy,
                  placeOrderState.balance,
                  _progressNotifier.value,
                  _amountController,
                  _priceController,
                  context,
                );
              },
              onSellTap: () {
                _onUpdateAvailableBalance(
                    orderSide: EnumBuySell.sell,
                    baseTokenId: coinProvider.tokenCoin.baseTokenId,
                    pairTokenId: coinProvider.tokenCoin.pairTokenId);
                _onProgressOrOrderSideUpdate(
                  EnumBuySell.sell,
                  placeOrderState.balance,
                  _progressNotifier.value,
                  _amountController,
                  _priceController,
                  context,
                );
              },
            ),
            SizedBox(height: 8),
            _orderTypeWidget(coinProvider),
            SizedBox(height: 8),
            _priceInputWidget(
              tokenId: coinProvider.tokenCoin.pairTokenId,
            ),
            SizedBox(height: 8),
            _amountInputWidget(
              tokenId: coinProvider.tokenCoin.baseTokenId,
              orderSide: placeOrderState.orderSide,
            ),
            SizedBox(height: 6),
            BlocConsumer<BalanceCubit, BalanceState>(
                listener: (context, balanceState) {
              _onUpdateAvailableBalance(
                  baseTokenId: coinProvider.tokenCoin.baseTokenId,
                  pairTokenId: coinProvider.tokenCoin.pairTokenId);
            }, builder: (context, balanceState) {
              if (balanceState is BalanceLoaded) {
                return _balanceWidget(
                  baseTokenId: coinProvider.tokenCoin.baseTokenId,
                  pairTokenId: coinProvider.tokenCoin.pairTokenId,
                );
              }

              return _balanceShimmerWidget();
            }),
            SizedBox(height: 16),
            _totalWidget(
              tokenId: coinProvider.tokenCoin.pairTokenId,
            ),
            placeOrderState is PlaceOrderLoading
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Center(
                      child: LoadingDotsWidget(
                        dotSize: 10,
                      ),
                    ),
                  )
                : AppButton(
                    label:
                        '${placeOrderState.orderSide == EnumBuySell.buy ? 'Buy' : 'Sell'} ${TokenUtils.tokenIdToAcronym(coinProvider.tokenCoin.baseTokenId)}',
                    enabled: _orderTypeNotifier.value == EnumOrderTypes.market
                        ? placeOrderState is TickerLoaded &&
                            placeOrderState is! PlaceOrderNotValid
                        : placeOrderState is! PlaceOrderNotValid,
                    onTap: () => _onBuyOrSell(
                      placeOrderState.orderSide,
                      _orderTypeNotifier.value,
                      coinProvider.tokenCoin.baseTokenId,
                      coinProvider.tokenCoin.pairTokenId,
                      _priceController.text,
                      _amountController.text,
                      context,
                    ),
                    innerPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 64),
                    outerPadding: EdgeInsets.symmetric(vertical: 8),
                    backgroundColor:
                        placeOrderState.orderSide == EnumBuySell.buy
                            ? AppColors.color0CA564
                            : AppColors.colorE6007A,
                  ),
          ],
        ),
      );
    });
  }

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

  void _onTapOrderType(
    BuildContext context,
    TradeTabCoinProvider coinProvider,
  ) {
    showOrderTypeDialog(
      context: context,
      selectedIndex: _orderTypeNotifier.value,
      onItemSelected: (index) {
        _orderTypeNotifier.value = index;

        if (index == EnumOrderTypes.market) {
          context.read<TickerCubit>().getLastTicker(
                leftTokenId: coinProvider.tokenCoin.baseTokenId,
                rightTokenId: coinProvider.tokenCoin.pairTokenId,
              );
        }
      },
    );
  }

  void _onUpdateAvailableBalance({
    required String baseTokenId,
    required String pairTokenId,
    EnumBuySell? orderSide,
  }) {
    final balanceCubit = context.read<BalanceCubit>();
    final balanceState = balanceCubit.state;

    if (balanceState is BalanceLoaded) {
      context.read<PlaceOrderCubit>().updateOrderParams(
          orderside: orderSide,
          balance: double.parse(balanceState.free[
              context.read<PlaceOrderCubit>().state.orderSide == EnumBuySell.buy
                  ? pairTokenId
                  : baseTokenId]));
      return;
    }

    context.read<PlaceOrderCubit>().updateOrderParams(balance: 0.0);
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

      if (walletBalance > 0.0) {
        _progressNotifier.value = ((amount * price) / walletBalance);
      } else {
        _progressNotifier.value = 0.0;
      }

      context.read<PlaceOrderCubit>().updateOrderParams(
            balance: walletBalance,
            amount: amount,
            price: price,
          );
    } catch (ex) {
      print(ex);
    }
  }

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
      amount: amount,
      price: price,
      address: context.read<AccountCubit>().accountAddress,
      signature: context.read<AccountCubit>().accountSignature,
    );

    if (price.isEmpty) {
      price = amount;
    }

    if (resultPlaceOrder != null &&
        resultPlaceOrder.orderType != EnumOrderTypes.market) {
      listOrdersCubit.addToOpenOrders(resultPlaceOrder);
    }

    final orderType = type == EnumBuySell.buy ? 'Purchase' : 'Sale';
    final message = context.read<PlaceOrderCubit>().state is PlaceOrderAccepted
        ? '$orderType order placed successfully.'
        : '$orderType order place failed. Please try again.';
    buildAppToast(msg: message, context: context);
  }

  Widget _evalTotalWidget(String tokenAcronym) {
    String? totalAmount;
    String totalPlaceholder = 'Total ($tokenAcronym)';

    try {
      final double? amount = double.tryParse(_amountController.text);
      final double? price = double.tryParse(_priceController.text);

      totalAmount =
          amount != null && price != null ? (amount * price).toString() : null;
    } on Exception catch (ex) {
      print(ex);
    }

    if ((totalAmount?.isEmpty ?? true) || (_progressNotifier.value == 0.0)) {
      totalAmount = totalPlaceholder;
    }

    return Text(
      totalAmount ?? totalPlaceholder,
      style: tsS16W500CFF,
    );
  }

  Widget _balanceWidget({
    required String baseTokenId,
    required String pairTokenId,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Available',
          style: tsS16W400CABB2BC,
        ),
        Text(
          '${context.read<PlaceOrderCubit>().state.balance} ${context.read<PlaceOrderCubit>().state.orderSide == EnumBuySell.buy ? TokenUtils.tokenIdToAcronym(pairTokenId) : TokenUtils.tokenIdToAcronym(baseTokenId)}',
          style: tsS16W600CFF,
        ),
      ],
    );
  }

  Widget _balanceShimmerWidget() {
    return Shimmer.fromColors(
      highlightColor: AppColors.color8BA1BE,
      baseColor: AppColors.color2E303C,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Available',
              style: tsS16W400CABB2BC,
            ),
            Text(
              '${context.read<PlaceOrderCubit>().state.balance} ${context.read<PlaceOrderCubit>().state.orderSide == EnumBuySell.buy ? TokenUtils.tokenIdToAcronym('0') : TokenUtils.tokenIdToAcronym('1')}',
              style: tsS16W600CFF,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buySellWidget({
    required EnumBuySell buySellEnumValue,
    VoidCallback? onBuyTap,
    VoidCallback? onSellTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTapDown: (_) {
            if (onBuyTap != null) {
              onBuyTap();
            }
          },
          child:
              _orderSideButton(isActive: buySellEnumValue == EnumBuySell.buy),
        ),
        GestureDetector(
          onTapDown: (_) {
            if (onSellTap != null) {
              onSellTap();
            }
          },
          child: _orderSideButton(
            isActive: buySellEnumValue == EnumBuySell.sell,
            isBuy: false,
          ),
        )
      ],
    );
  }

  Widget _priceInputWidget({required String tokenId}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.color3B4150,
        border: Border.all(color: AppColors.color558BA1BE),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: QuantityInputWidget(
        hintText: 'Price (${TokenUtils.tokenIdToAcronym(tokenId)})',
        controller: _priceController,
        onChanged: (price) => _onPriceAmountChanged(
          context,
          context.read<PlaceOrderCubit>().state.balance,
          price,
          false,
        ),
      ),
    );
  }

  Widget _amountInputWidget({
    required String tokenId,
    EnumBuySell orderSide = EnumBuySell.buy,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.color3B4150,
        border: Border.all(color: AppColors.color558BA1BE),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          QuantityInputWidget(
            hintText: 'Amount (${TokenUtils.tokenIdToAcronym(tokenId)})',
            controller: _amountController,
            onChanged: (amount) => _onPriceAmountChanged(
              context,
              context.read<PlaceOrderCubit>().state.balance,
              amount,
              true,
            ),
          ),
          SizedBox(height: 24),
          ValueListenableBuilder<double>(
            valueListenable: _progressNotifier,
            builder: (context, progress, child) {
              return AppHorizontalSlider(
                bgColor: Colors.white,
                activeColor: orderSide == EnumBuySell.buy
                    ? AppColors.color0CA564
                    : AppColors.colorE6007A,
                initialProgress: progress.clamp(0.0, 1.0),
                onProgressUpdate: (progress) {
                  _progressNotifier.value = progress;
                  _onProgressOrOrderSideUpdate(
                    context.read<PlaceOrderCubit>().state.orderSide,
                    context.read<PlaceOrderCubit>().state.balance,
                    progress,
                    _amountController,
                    _priceController,
                    context,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _totalWidget({required String tokenId}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.color3B4150,
        border: Border.all(color: AppColors.color558BA1BE),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      alignment: Alignment.center,
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _evalTotalWidget(TokenUtils.tokenIdToAcronym(tokenId)),
        ),
      ),
    );
  }

  Widget _orderTypeWidget(TradeTabCoinProvider coinProvider) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.color3B4150,
        border: Border.all(color: AppColors.color558BA1BE),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: GestureDetector(
        onTapUp: (_) => _onTapOrderType(context, coinProvider),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder<EnumOrderTypes>(
              valueListenable: _orderTypeNotifier,
              builder: (context, type, _) => Text(
                _getOrderTypeName(type),
                style: tsS15W600CFF,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 18,
            )
          ],
        ),
      ),
    );
  }

  Widget _orderSideButton({
    bool isActive = false,
    bool isBuy = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? (isBuy ? AppColors.color0CA564 : AppColors.colorE6007A)
            : AppColors.color3B4150,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.symmetric(vertical: 20),
      width: (AppConfigs.size.width / 4) - 6,
      child: Align(
        alignment: Alignment.center,
        child: isBuy
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'buy_circle'.asAssetSvg(),
                    height: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Buy',
                    style: tsS18W600CFF,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'sell_circle'.asAssetSvg(),
                    height: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Sell',
                    style: tsS18W600CFF,
                  ),
                ],
              ),
      ),
    );
  }
}
