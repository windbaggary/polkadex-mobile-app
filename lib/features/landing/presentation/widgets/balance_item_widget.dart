import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';

class BalanceItemWidget extends StatelessWidget {
  const BalanceItemWidget({
    required this.tokenAcronym,
    required this.tokenFullName,
    required this.assetSvg,
    required this.amount,
  });

  final String tokenAcronym;
  final String tokenFullName;
  final String assetSvg;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(15, 14, 10, 14),
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
            child: SvgPicture.asset(
              assetSvg,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tokenFullName,
                style: tsS16W500CFF,
              ),
              Text(
                tokenAcronym,
                style: tsS13W500CFF.copyWith(color: AppColors.colorABB2BC),
              ),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$amount',
                style: tsS16W500CFF,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
