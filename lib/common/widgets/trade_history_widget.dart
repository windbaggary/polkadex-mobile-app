import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/trades/domain/entities/account_trade_entity.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/polkadex_progress_error_widget.dart';
import 'package:polkadex/features/coin/presentation/cubits/trade_history_cubit/trade_history_cubit.dart';
import 'package:shimmer/shimmer.dart';

class TradeHistoryWidget extends StatelessWidget {
  TradeHistoryWidget({this.asset});

  final AssetEntity? asset;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TradeHistoryCubit, TradeHistoryState>(
      builder: (context, state) {
        if (state is TradeHistoryLoaded) {
          return state.trades.isEmpty
              ? Padding(
                  padding: EdgeInsets.fromLTRB(18, 26.0, 18, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 36, bottom: 36),
                        child: Text(
                          "There are no transactions",
                          style: tsS16W500CABB2BC,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.trades.length,
                  padding: const EdgeInsets.only(top: 13),
                  itemBuilder: (context, index) {
                    return _ThisItemWidget(
                      tradeItem: state.trades[index],
                      dateTitle: _getDateTitle(state.trades[index].time,
                          index > 0 ? state.trades[index - 1].time : null),
                    );
                  },
                );
        }

        if (state is TradeHistoryError) {
          return Container(
            height: 50,
            child: PolkadexErrorRefreshWidget(
              onRefresh: () => context
                  .read<TradeHistoryCubit>()
                  .getAccountTrades(
                    asset: asset?.assetId,
                    address: context.read<AccountCubit>().mainAccountAddress,
                  ),
            ),
          );
        }

        return _buildOrderHistoryShimmerWidget();
      },
    );
  }

  Widget _buildOrderHistoryShimmerWidget() {
    return Shimmer.fromColors(
      highlightColor: AppColors.color8BA1BE,
      baseColor: AppColors.color2E303C,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.fromLTRB(14, 17, 14, 17),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.colorFFFFFF,
                ),
                width: 42,
                height: 42,
                padding: const EdgeInsets.all(3),
              ),
              SizedBox(width: 9),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'DOT/BTC',
                      style: tsS16W500CFF,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '10:12:07 AM',
                      style:
                          tsS13W500CFF.copyWith(color: AppColors.colorABB2BC),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '0.451 DOT / 0.451 DOT',
                      style: tsS16W500CFF,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        itemCount: 3,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
      ),
    );
  }

  String? _getDateTitle(DateTime date, DateTime? previousDate) {
    final dateString = _getDateString(date);
    final datePreviousString =
        previousDate != null ? _getDateString(previousDate) : '';

    return dateString != datePreviousString ? dateString : null;
  }

  String _getDateString(DateTime date) {
    final today = DateTime.now();
    if (date.day == today.day &&
        date.month == today.month &&
        date.year == today.year) {
      return "Today";
    } else if (date.day == today.day - 1 &&
        date.month == today.month &&
        date.year == today.year) {
      return "Yesterday";
    } else {
      return DateFormat("dd MMMM, yyyy").format(date);
    }
  }
}

class _ThisItemWidget extends StatelessWidget {
  final AccountTradeEntity tradeItem;
  final String? dateTitle;

  const _ThisItemWidget({
    required this.tradeItem,
    required this.dateTitle,
  });

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
