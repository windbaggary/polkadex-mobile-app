import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/trades/domain/entities/account_trade_entity.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';

class TradeItemWidget extends StatelessWidget {
  const TradeItemWidget({
    required this.tradeItem,
    required this.dateTitle,
  });

  final AccountTradeEntity tradeItem;
  final String? dateTitle;

  @override
  Widget build(BuildContext context) {
    Widget child = Container();

    switch (tradeItem.txnType) {
      case EnumTradeTypes.deposit:
      case EnumTradeTypes.withdraw:
        child = _buildHistoryTradeItemWidget(context, tradeItem);
        break;
      default:
        child = Container();
    }

    final cardWidget = Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.fromLTRB(14, 17, 14, 17),
        child: child,
      ),
    );

    if (dateTitle?.isNotEmpty ?? false) {
      final double topPadding =
          ['Today', 'Yesterday'].contains(dateTitle) ? 7.0 : 26.0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18, topPadding, 18, 10),
            child: Text(
              dateTitle ?? "",
              style: tsS16W500CFF,
            ),
          ),
          cardWidget,
        ],
      );
    }

    return cardWidget;
  }

  Widget _buildHistoryTradeItemWidget(
      BuildContext context, AccountTradeEntity trade) {
    final cubit = context.read<MarketAssetCubit>();
    Widget mainIcon;

    switch (trade.txnType) {
      case EnumTradeTypes.deposit:
        mainIcon = SvgPicture.asset(
          'Deposit'.asAssetSvg(),
        );
        break;
      case EnumTradeTypes.withdraw:
        mainIcon = SvgPicture.asset(
          'Withdraw'.asAssetSvg(),
        );
        break;
      default:
        mainIcon = Container();
    }

    return Row(
      children: [
        Container(
          width: 47,
          height: 47,
          margin: const EdgeInsets.only(right: 4.2),
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 13),
          decoration: BoxDecoration(
              color: AppColors.color8BA1BE.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12)),
          child: mainIcon,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                cubit.getAssetDetailsById(trade.asset).symbol,
                style: tsS15W500CFF,
              ),
              SizedBox(height: 1),
              Text(
                DateFormat("hh:mm:ss aa").format(trade.time).toUpperCase(),
                style: tsS13W400CFFOP60.copyWith(color: AppColors.colorABB2BC),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  '${trade.amount} ${cubit.getAssetDetailsById(trade.asset).symbol}',
                  style: tsS14W500CFF.copyWith(
                    color: trade.txnType == EnumTradeTypes.deposit
                        ? AppColors.color0CA564
                        : AppColors.colorE6007A,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
