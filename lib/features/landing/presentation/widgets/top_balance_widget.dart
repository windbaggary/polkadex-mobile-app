import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:shimmer/shimmer.dart';

class TopBalanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceCubit, BalanceState>(
      builder: (context, state) {
        final Widget mainBalanceValueWidget;
        final Widget secondaryBalanceValueWidget;

        if (state is BalanceLoaded) {
          mainBalanceValueWidget = Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: '0.8713 ',
                    style: tsS32W600CFF,
                  ),
                  TextSpan(
                    text: 'BTC ',
                    style: tsS15W600CFF,
                  ),
                ],
              ),
            ),
          );
          secondaryBalanceValueWidget = RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '~437.50 ',
                  style: tsS19W400CFF,
                ),
                TextSpan(
                  text: 'USD',
                  style: tsS12W400CFF,
                ),
              ],
            ),
          );
        } else if (state is BalanceError) {
          mainBalanceValueWidget = Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: '- ',
                    style: tsS32W600CFF,
                  ),
                  TextSpan(
                    text: 'BTC ',
                    style: tsS15W600CFF,
                  ),
                ],
              ),
            ),
          );
          secondaryBalanceValueWidget = RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '- ',
                  style: tsS19W400CFF,
                ),
                TextSpan(
                  text: 'USD',
                  style: tsS12W400CFF,
                ),
              ],
            ),
          );
        } else {
          mainBalanceValueWidget = _mainBTCBalanceShimmerWidget();
          secondaryBalanceValueWidget = _secondaryUSDBalanceShimmerWidget();
        }

        return Column(
          children: [
            Center(
              child: Container(
                width: 42,
                height: 42,
                margin: const EdgeInsets.only(bottom: 9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: color8BA1BE.withOpacity(0.30),
                ),
                padding: const EdgeInsets.all(11),
                child: SvgPicture.asset('wallet_selected'.asAssetSvg()),
              ),
            ),
            Text(
              'Total Balance',
              style: tsS15W400CFF.copyWith(color: colorABB2BC),
              textAlign: TextAlign.center,
            ),
            mainBalanceValueWidget,
            SizedBox(height: 4),
            secondaryBalanceValueWidget,
          ],
        );
      },
    );
  }

  Widget _mainBTCBalanceShimmerWidget() {
    return Shimmer.fromColors(
      highlightColor: color8BA1BE,
      baseColor: color2E303C,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '0.8713 ',
                  style: tsS32W600CFF,
                ),
                TextSpan(
                  text: 'BTC ',
                  style: tsS15W600CFF,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _secondaryUSDBalanceShimmerWidget() {
    return Shimmer.fromColors(
      highlightColor: color8BA1BE,
      baseColor: color2E303C,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '~437.50 ',
                style: tsS19W400CFF,
              ),
              TextSpan(
                text: 'USD',
                style: tsS12W400CFF,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
