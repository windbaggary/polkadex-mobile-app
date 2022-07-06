import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/trades/presentation/cubits/order_history_cubit/order_history_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/place_order_cubit/place_order_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/ticker_cubit/ticker_cubit.dart';
import 'package:polkadex/features/landing/presentation/dialogs/trade_view_dialogs.dart';
import 'package:polkadex/common/widgets/app_horizontal_slider.dart';
import 'package:polkadex/common/widgets/loading_dots_widget.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/features/landing/presentation/widgets/quantity_input_widget.dart';
import 'package:polkadex/common/utils/math_utils.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/colors.dart';
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
    return BlocBuilder<MarketAssetCubit, MarketAssetState>(
      builder: (context, state) {
        final cubit = context.read<MarketAssetCubit>();

        _onUpdateAvailableBalance(
            baseToken: cubit.currentBaseAssetDetails,
            pairToken: cubit.currentQuoteAssetDetails);

        return BlocBuilder<PlaceOrderCubit, PlaceOrderState>(
          builder: (context, placeOrderState) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buySellWidget(
                buySellEnumValue: placeOrderState.orderSide,
                onBuyTap: () => _onTapOrderSide(
                  EnumBuySell.buy,
                  context.read<BalanceCubit>(),
                  cubit,
                ),
                onSellTap: () => _onTapOrderSide(
                  EnumBuySell.sell,
                  context.read<BalanceCubit>(),
                  cubit,
                ),
              ),
              SizedBox(height: 8),
              _orderTypeWidget(cubit),
              SizedBox(height: 8),
              _priceInputWidget(
                marketAssetCubit: cubit,
                placeOrderState: placeOrderState,
              ),
              SizedBox(height: 8),
              _amountInputWidget(
                asset: cubit.currentBaseAssetDetails,
                orderSide: placeOrderState.orderSide,
              ),
              SizedBox(height: 6),
              BlocConsumer<BalanceCubit, BalanceState>(
                  listener: (context, balanceState) {
                _onUpdateAvailableBalance(
                    baseToken: cubit.currentBaseAssetDetails,
                    pairToken: cubit.currentQuoteAssetDetails);
              }, builder: (context, balanceState) {
                if (balanceState is BalanceLoaded) {
                  return _balanceWidget(
                    baseToken: cubit.currentBaseAssetDetails,
                    pairToken: cubit.currentQuoteAssetDetails,
                  );
                }

                return _balanceShimmerWidget(
                  baseToken: cubit.currentBaseAssetDetails,
                  pairToken: cubit.currentQuoteAssetDetails,
                );
              }),
              SizedBox(height: 16),
              _totalWidget(
                token: cubit.currentBaseAssetDetails,
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
                  : ValueListenableBuilder<EnumOrderTypes>(
                      valueListenable: _orderTypeNotifier,
                      builder: (_, __, ___) => AppButton(
                        label:
                            '${placeOrderState.orderSide == EnumBuySell.buy ? 'Buy' : 'Sell'} ${cubit.currentBaseAssetDetails.symbol}',
                        enabled:
                            _orderTypeNotifier.value == EnumOrderTypes.market
                                ? context.read<TickerCubit>().state
                                        is TickerLoaded &&
                                    placeOrderState is! PlaceOrderNotValid
                                : placeOrderState is! PlaceOrderNotValid,
                        onTap: () => _onBuyOrSell(
                          placeOrderState.orderSide,
                          _orderTypeNotifier.value,
                          cubit.currentBaseAssetDetails.assetId,
                          cubit.currentQuoteAssetDetails.assetId,
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
                    ),
            ],
          ),
        );
      },
    );
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

  _onTapOrderSide(
    EnumBuySell enumBuySell,
    BalanceCubit balanceCubit,
    MarketAssetCubit marketAssetCubit,
  ) {
    final balanceState = balanceCubit.state;
    double balance;

    if (balanceState is BalanceLoaded) {
      balance = double.parse(balanceState.free.getBalance(
          enumBuySell == EnumBuySell.buy
              ? marketAssetCubit.currentQuoteAssetDetails.assetId
              : marketAssetCubit.currentBaseAssetDetails.assetId));
    } else {
      balance = 0.0;
    }

    _onProgressOrOrderSideUpdate(
      enumBuySell,
      balance,
      _progressNotifier.value,
      _amountController,
      _priceController,
      context,
    );
  }

  void _onTapOrderType(
    BuildContext context,
    MarketAssetCubit marketAssetCubit,
  ) {
    showOrderTypeDialog(
      context: context,
      selectedIndex: _orderTypeNotifier.value,
      onItemSelected: (index) {
        _orderTypeNotifier.value = index;

        if (index == EnumOrderTypes.market) {
          _priceController.text = '';
          WidgetsBinding.instance
              ?.addPostFrameCallback((_) => _onPriceAmountChanged(
                    context.read<PlaceOrderCubit>(),
                    0.0,
                    false,
                  ));
        }
      },
    );
  }

  void _onUpdateAvailableBalance({
    required AssetEntity baseToken,
    required AssetEntity pairToken,
    EnumBuySell? orderSide,
  }) {
    final balanceCubit = context.read<BalanceCubit>();
    final balanceState = balanceCubit.state;
    final newOrderSide =
        orderSide ?? context.read<PlaceOrderCubit>().state.orderSide;

    if (balanceState is BalanceLoaded) {
      context.read<PlaceOrderCubit>().updateOrderParams(
            orderside: newOrderSide,
            balance: double.parse(
              balanceState.free.getBalance(newOrderSide == EnumBuySell.buy
                  ? pairToken.assetId
                  : baseToken.assetId),
            ),
          );
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
      context.read<PlaceOrderCubit>().updateOrderParams(
            orderside: buyOrSell,
            balance: walletBalance,
          );
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
    PlaceOrderCubit placeOrderCubit,
    double val,
    bool isAmount,
  ) {
    double amount;
    double price;
    final walletBalance = placeOrderCubit.state.balance;

    try {
      if (isAmount) {
        amount = val;
        price = double.tryParse(_priceController.text) ?? 0.0;
      } else {
        amount = double.tryParse(_amountController.text) ?? 0.0;
        price = val;
      }

      if (walletBalance > 0.0) {
        _progressNotifier.value = ((amount * price) / walletBalance);
      } else {
        _progressNotifier.value = 0.0;
      }

      placeOrderCubit.updateOrderParams(
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
    final orderHistoryCubit = context.read<OrderHistoryCubit>();

    FocusManager.instance.primaryFocus?.unfocus();

    final resultPlaceOrder = await placeOrderCubit.placeOrder(
      mainAddress: context.read<AccountCubit>().mainAccountAddress,
      proxyAddress: context.read<AccountCubit>().proxyAccountAddress,
      baseAsset: leftAsset,
      quoteAsset: rightAsset,
      orderType: side,
      orderSide: type,
      amount: amount,
      price: price,
    );

    if (price.isEmpty) {
      price = amount;
    }

    if (resultPlaceOrder != null &&
        resultPlaceOrder.orderType != EnumOrderTypes.market) {
      orderHistoryCubit.addToOpenOrders(resultPlaceOrder);
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
    required AssetEntity baseToken,
    required AssetEntity pairToken,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Available',
          style: tsS16W400CABB2BC,
        ),
        Flexible(
          child: Text(
            '${context.read<PlaceOrderCubit>().state.balance}',
            style: tsS16W600CFF,
            overflow: TextOverflow.clip,
            maxLines: 1,
          ),
        ),
        Text(
          context.read<PlaceOrderCubit>().state.orderSide == EnumBuySell.buy
              ? pairToken.symbol
              : baseToken.symbol,
          style: tsS16W600CFF,
        ),
      ],
    );
  }

  Widget _balanceShimmerWidget({
    required AssetEntity baseToken,
    required AssetEntity pairToken,
  }) {
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
              '${context.read<PlaceOrderCubit>().state.balance} ${context.read<PlaceOrderCubit>().state.orderSide == EnumBuySell.buy ? baseToken.symbol : baseToken.symbol}',
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

  Widget _priceInputWidget({
    required MarketAssetCubit marketAssetCubit,
    required PlaceOrderState placeOrderState,
  }) {
    return ValueListenableBuilder<EnumOrderTypes>(
      valueListenable: _orderTypeNotifier,
      builder: (context, orderType, child) =>
          BlocBuilder<TickerCubit, TickerState>(
        builder: (context, state) {
          if (state is TickerLoaded &&
              placeOrderState is! PlaceOrderLoading &&
              orderType == EnumOrderTypes.market) {
            final placeOrderCubit = context.read<PlaceOrderCubit>();
            final newPrice = state
                    .ticker[context.read<MarketAssetCubit>().currentMarketId]
                    ?.close ??
                0.0;

            _priceController.text = newPrice.toString();
            WidgetsBinding.instance
                ?.addPostFrameCallback((_) => _onPriceAmountChanged(
                      placeOrderCubit,
                      newPrice,
                      false,
                    ));
          }

          return Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.color3B4150,
              border: Border.all(color: AppColors.color558BA1BE),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: IgnorePointer(
              ignoring: _orderTypeNotifier.value == EnumOrderTypes.market &&
                  state is TickerLoaded,
              child: QuantityInputWidget(
                hintText:
                    'Price (${marketAssetCubit.currentQuoteAssetDetails.symbol})',
                controller: _priceController,
                onChanged: (price) => _onPriceAmountChanged(
                  context.read<PlaceOrderCubit>(),
                  double.parse(price),
                  false,
                ),
                isLoading: _orderTypeNotifier.value == EnumOrderTypes.market &&
                    state is TickerLoading,
                onError: _orderTypeNotifier.value == EnumOrderTypes.market &&
                        state is TickerError
                    ? () => context.read<TickerCubit>().getAllTickers()
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _amountInputWidget({
    required AssetEntity asset,
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
            hintText: 'Amount (${asset.symbol})',
            controller: _amountController,
            onChanged: (amount) => _onPriceAmountChanged(
              context.read<PlaceOrderCubit>(),
              double.parse(amount),
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

  Widget _totalWidget({required AssetEntity token}) {
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: _evalTotalWidget(token.symbol),
      ),
    );
  }

  Widget _orderTypeWidget(MarketAssetCubit marketAssetCubit) {
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
        onTapUp: (_) => _onTapOrderType(context, marketAssetCubit),
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
      constraints: BoxConstraints(
        maxWidth: (AppConfigs.size.width / 4) - 10,
      ),
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
