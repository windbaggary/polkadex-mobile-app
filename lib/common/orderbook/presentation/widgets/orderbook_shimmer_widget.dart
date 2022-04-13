import 'package:flutter/material.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/orderbook/presentation/widgets/orderbook_heading_widget.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:shimmer/shimmer.dart';

/// The order book widget
class OrderBookShimmerWidget extends StatelessWidget {
  const OrderBookShimmerWidget();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: AppColors.color8BA1BE,
      baseColor: AppColors.color2E303C,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
        ),
        height: 480,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: OrderBookHeadingWidget(
                marketDropDownNotifier: ValueNotifier<EnumMarketDropdownTypes>(
                    EnumMarketDropdownTypes.orderbook),
                priceLengthNotifier: ValueNotifier<int>(0),
              ),
            ),
            _ThisOrderBookChartWidget(),
          ],
        ),
      ),
    );
  }
}

/// The widget displays the chart on order book content
class _ThisOrderBookChartWidget extends StatelessWidget {
  _ThisOrderBookChartWidget();

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppConfigs.animDurationSmall,
      child: Column(
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
                child: SizedBox(height: 100),
              ),
              SizedBox(width: 7),
              Expanded(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeadingWidget() => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Amount ()',
                style: tsS13W500CFFOP40,
              ),
            ),
            Text(
              'Price ()',
              style: tsS13W500CFFOP40,
              textAlign: TextAlign.end,
            )
          ],
        ),
      );
}
