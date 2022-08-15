import 'package:flutter/material.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';

class TopPairWidget extends StatelessWidget {
  const TopPairWidget({
    required this.leftAsset,
    required this.rightAsset,
    required this.onTap,
    this.ticker,
  });

  final AssetEntity leftAsset;
  final AssetEntity rightAsset;
  final VoidCallback onTap;
  final TickerEntity? ticker;

  @override
  Widget build(BuildContext context) {
    return buildInkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.color2E303C.withOpacity(0.30),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.fromLTRB(16, 16, 14, 16.0),
        child: IntrinsicWidth(
          child: Column(
            children: [
              Row(
                children: [
                  RichText(
                      text: TextSpan(style: tsS14W400CFF, children: <TextSpan>[
                    TextSpan(text: '${leftAsset.symbol}/'),
                    TextSpan(
                      text: rightAsset.symbol,
                      style: tsS16W700CFF,
                    ),
                  ])),
                  SizedBox(
                    width: 36,
                  ),
                  Spacer(),
                  Text(
                    ticker != null
                        ? '${ticker?.priceChangePercent24Hr.toStringAsFixed(2)}%'
                        : '',
                    style: tsS17W600C0CA564,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price',
                        style: tsS14W400CFFOP50,
                      ),
                      SizedBox(height: 4),
                      Text(
                        ticker?.volumeBase24hr.toStringAsFixed(2) ?? '',
                        style: tsS16W600CFF,
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vol',
                        style: tsS14W400CFFOP50,
                      ),
                      SizedBox(height: 4),
                      Text(
                        ticker?.volumeBase24hr.toStringAsFixed(4) ?? '',
                        style: tsS16W600CFF,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
