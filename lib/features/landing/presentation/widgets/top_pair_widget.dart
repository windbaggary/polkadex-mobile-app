import 'package:flutter/material.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:provider/provider.dart';

class TopPairWidget extends StatelessWidget {
  const TopPairWidget({
    required this.leftAsset,
    required this.rightAsset,
    required this.onTap,
  });

  final String leftAsset;
  final String rightAsset;
  final VoidCallback onTap;

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
                    TextSpan(
                        text: '${TokenUtils.tokenIdToAcronym(leftAsset)}/'),
                    TextSpan(
                      text: TokenUtils.tokenIdToAcronym(rightAsset),
                      style: tsS16W700CFF,
                    ),
                  ])),
                  SizedBox(
                    width: 36,
                  ),
                  Spacer(),
                  Text(
                    '12.47%',
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
                        '\$42.50',
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
                        '\$824.1mi',
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
