import 'package:flutter/material.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/orderbook/presentation/widgets/orderbook_heading_widget.dart';
import 'package:polkadex/common/utils/colors.dart';
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
        child: Column(
          children: [
            OrderBookHeadingWidget(),
            Column(
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
                          style: tsS20W600CFF.copyWith(
                              color: AppColors.color0CA564),
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
            )
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
