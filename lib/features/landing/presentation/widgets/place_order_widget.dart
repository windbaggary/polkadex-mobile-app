import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/place_order_cubit/place_order_cubit.dart';
import 'package:polkadex/features/landing/presentation/providers/trade_tab_provider.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
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
              onBuyTap: () => _onUpdateAvailableBalance(
                  orderSide: EnumBuySell.buy,
                  baseTokenId: coinProvider.tokenCoin.baseTokenId,
                  pairTokenId: coinProvider.tokenCoin.pairTokenId),
              onSellTap: () => _onUpdateAvailableBalance(
                  orderSide: EnumBuySell.sell,
                  baseTokenId: coinProvider.tokenCoin.baseTokenId,
                  pairTokenId: coinProvider.tokenCoin.pairTokenId),
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
            AppButton(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 64),
              label:
                  '${placeOrderState.orderSide == EnumBuySell.buy ? 'Buy' : 'Sell'} ${TokenUtils.tokenIdToAcronym(coinProvider.tokenCoin.baseTokenId)}',
              enabled: true,
              onTap: () {},
              backgroundColor: placeOrderState.orderSide == EnumBuySell.buy
                  ? AppColors.color0CA564
                  : AppColors.colorE6007A,
            ),
          ],
        ),
      );
    });
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
